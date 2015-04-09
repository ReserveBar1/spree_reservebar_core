class ProductSalesReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default from: "noreply@reservebar.com"

  def send_report(order_ids, user_id)
    @current_user = Spree::User.find user_id
    @orders = Spree::Order.where(id: order_ids).includes(:line_items,
      :retailers, :ship_address)

    filename = "product_sales_report_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
    attachments[filename] = {
      mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252',
        :undef => :replace, replace: '')
    }

    mail(to: @current_user.email, reply_to: "noreply@reservebar.com",
      subject: "Your Product Sales report is ready",
      body: "Please find your report attached.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = [
      "OrderNumber",
      "Customer email address",
      "Ship-to State",
      "Product name",
      "Partner",
      "Brand",
      "Brand Owner",
      "Number of bottles",
      "Multiple products in the order",
      "OrderDate",
      "AcceptedDate",
      "OrderState",
      "PaymentState",
      "ShipmentState",
      "Website Product Price",
      "Fulfillment Fee",
      "Shipping Surcharge",
      "Corrugated Box Fee",
      "Net Shipping Surcharge",
      "Retailer Product Cost",
      "ReserveBar Margin",
      "Gift Packaging Price to Customer",
      "Gift Packaging Cost",
      "Gift Packaging Margin",
      "Total Margin",
      "Promo",
      "Total promo discount($)",
      "Retailer",
      "Is a gift?"
    ]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        line_items = order.line_items

        # Corrugated Box fee based on Retailers
        retailer_name = order.retailer.name 
        if retailer_name == 'Sunset Corners'
          corrugated_box_fee = 5
        elsif retailer_name == 'Mel and Rose Wine'
          corrugated_box_fee = line_items.count < 3 ? 3 : 6
        else
          corrugated_box_fee = 3
        end
        corrugated_box_fee_per_li = corrugated_box_fee / line_items.count

        fulfillment_fee_per_li = order.fulfillment_fee / line_items.count

        line_items.each do |li|
          net_shipping_surcharge = li.shipping_surcharge * li.quantity - corrugated_box_fee_per_li
          rb_margin = (li.price + fulfillment_fee_per_li) * li.quantity + net_shipping_surcharge - li.product_cost_for_retailer

          # already takes quantity into account
          gift_packaging_price = li.adjustments.eligible.gift_packaging.map(&:amount).sum
          gift_packaging_cost = (gift_packaging_price / 10) * Spree::CompanyCost.find_by_name("Gift Packaging: Suede Bag").value.to_f
          gift_packaging_margin = gift_packaging_price - gift_packaging_cost

          csv << [
            order.number,
            order.email,
            order.ship_address.state.abbr,
            li.product.nil? ? nil : strip_tags(li.product.name).gsub(/&quot;|,/, ''),
            li.product.nil? ? nil : li.product.partner.try(:name),
            li.product.nil? ? nil : li.product.try(:brand).try(:title),
            li.product.nil? ? nil : li.product.try(:brand).try(:brand_owner).try(:title),
            li.quantity,
            (line_items.size > 1 ? "Yes" : "No"),
            (@show_only_completed ? order.completed_at : order.created_at).to_date,
            order.accepted_at.nil? ? nil : order.accepted_at.to_date,
            order.present? ? order.state : nil,
            order.payment_state,
            order.shipment_state,
            number_to_currency(li.price),
            number_to_currency(fulfillment_fee_per_li),
            number_to_currency(li.shipping_surcharge),
            number_to_currency(corrugated_box_fee_per_li),
            number_to_currency(net_shipping_surcharge),
            number_to_currency(li.product_cost_for_retailer),
            number_to_currency(rb_margin),
            number_to_currency(gift_packaging_price),
            number_to_currency(gift_packaging_cost),
            number_to_currency(gift_packaging_margin),
            number_to_currency(rb_margin + gift_packaging_margin),
            order.adjustments.eligible.promotion.first.try(:label),
            number_to_currency(order.adjustments.eligible.promotion.first.try(:amount)),
            order.retailer.try(:name),
            order.is_gift? ? 'Yes' : ''
          ]
        end
      end
    end
  end

  def non_admin_report
    column_names = ["OrderNumber", "ProductName", "NumberOfBottles", "MultipleProductsPerOrder", "OrderState", "PaymentState", "ShipmentState", "ProductCostForRetailer"]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        line_items = order.line_items
        line_items.each do |line_item|
          csv << [order.number,
            line_item.product.nil? ? nil : strip_tags(line_item.product.name).gsub(/&quot;|,/, ''),
            line_item.quantity,
            (line_items.size > 1 ? "Yes" : "No"),
            order.state,
            order.payment_state,
            order.shipment_state,
            line_item.product_cost_for_retailer
          ]
        end
      end
    end
  end

  def report_csv_file
    if admin_user?
      admin_report
    else
      non_admin_report
    end
  end

end
