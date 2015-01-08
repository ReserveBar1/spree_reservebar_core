class ProductSalesReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default :from => "noreply@reservebar.com"

  def send_report(order_ids, user_id)
    @current_user = Spree::User.find user_id
    @orders = Spree::Order.where(id: order_ids).includes(:line_items,
      :retailers, :ship_address)

    attachments["product_sales_report.csv"] = { mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252', :undef => :replace, replace: '') }
    mail(to: @current_user.email, reply_to: "noreply@reservebar.com",
      subject: "Your product sales report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = [
      "OrderNumber",
      "Order details link",
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
      "Product price",
      "GiftPackagingCost(not paid to retailer)",
      "RB margin (Product price - product cost)",
      "Promo",
      "Total promo discount($)",
      "Retailer",
      "ProductCostForRetailer",
      "Is a gift?"
    ]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        line_items = order.line_items
        line_items.each do |line_item|
        csv << [
          order.number,
          spree.order_url(order, :protocol => 'https'),
          order.email,
          order.ship_address.state.abbr,
          line_item.product.nil? ? nil : strip_tags(line_item.product.name).gsub(/&quot;|,/, ''),
          line_item.product.nil? ? nil : line_item.product.partner.try(:name),
          line_item.product.nil? ? nil : line_item.product.brand.title,
          line_item.product.nil? ? nil : line_item.product.brand.brand_owner.title,
          line_item.quantity,
          (line_items.size > 1 ? "Yes" : "No"),
          (@show_only_completed ? order.completed_at : order.created_at).to_date,
          order.accepted_at.nil? ? nil : order.accepted_at.to_date,
          order.present? ? order.state : nil,
          order.payment_state,
          order.shipment_state,
          number_to_currency(line_item.price),
          number_to_currency(line_item.adjustments.eligible.gift_packaging.map(&:amount).sum),
          number_to_currency(line_item.margin_for_site),
          order.adjustments.eligible.promotion.first.try(:label),
          number_to_currency(order.adjustments.eligible.promotion.first.try(:amount)),
          order.retailer.try(:name),
          number_to_currency(line_item.product_cost_for_retailer),
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
