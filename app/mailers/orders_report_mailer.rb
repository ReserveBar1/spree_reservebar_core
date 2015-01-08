class OrdersReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default :from => "noreply@reservebar.com"

  def send_report(order_ids, user_id)
    @current_user = Spree::User.find user_id
    @orders = Spree::Order.where(id: order_ids).includes(:line_items,
      :retailers, :profit_and_loss)
    @orders.each do |order|
      order.build_profit_and_loss if order.profit_and_loss.nil?
    end

    attachments["orders_report.csv"] = { mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252', :undef => :replace, replace: '') }
    mail(to: @current_user.email, reply_to: "noreply@reservebar.com",
      subject: "Your orders report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = [
      "Order Number",
      "Order Date",
      "Accepted Date",
      "Product Name(s)",
      "Brand Name(s)",
      "Brand Owner(s)",
      "Number of Bottles",
      "Website Product Price",
      "Total Bottle Price",
      "Gift Packaging Charge (not paid to retailer)",
      "Gift Packaging Cost",
      "Corrugated Cost",
      "Shipping Charge",
      "State Fulfillment Fee",
      "Tax",
      "Promo discount($)",
      "Order Total",
      "Retail Bottle Price",
      "Credit Card Fees",
      "Total Disbursement To Retailer (product cost + sales tax + cc fees)",
      "Promo name",
      "Groupon Code",
      "Order Status",
      "Payment Status",
      "Shipment Status",
      "Retailer",
      "Ship-to State",
      "Customer email address",
      "Is a gift?"
    ]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        line_items = order.line_items
        profit_and_loss = order.profit_and_loss
        retailer = order.retailer

        product_names = line_items.map{ |li| li.product.try(:name) }.compact
        brand_names = line_items.map{ |li| li.product.brand.title }.compact
        brand_owner_names = line_items.map{ |li| li.product.brand.brand_owner.title }.compact
        prices = line_items.map{ |li| li.price }.compact
        prices = prices.map { |p| number_to_currency(p) } if prices.present?
        shipping_charge_uplift = order.shipping_method.calculator.preferred_uplift rescue 0.0

        csv << [
          order.number,
          (order.completed_at.nil? ? order.created_at : order.completed_at).to_date,
          order.accepted_at.nil? ? nil : order.accepted_at.to_date,
          product_names.empty? ? nil : strip_tags(product_names.join('|')).gsub(/&quot;|,/, ''),
          brand_names.empty? ? nil : strip_tags(brand_names.join('|')).gsub(/&quot;|,/, ''),
          brand_owner_names.empty? ? nil : strip_tags(brand_owner_names.join('|')).gsub(/&quot;|,/, ''),
          order.number_of_bottles,
          prices.empty? ? nil : prices.join('|'),
          number_to_currency(profit_and_loss.total_bottle_price),
          number_to_currency(profit_and_loss.gift_packaging_charge),
          number_to_currency(profit_and_loss.gift_packaging_cost),
          number_to_currency(profit_and_loss.corrugated_cost),
          number_to_currency(profit_and_loss.shipping_costs),
          number_to_currency(profit_and_loss.state_fulfillment_fee),
          number_to_currency(profit_and_loss.sales_tax),
          number_to_currency(profit_and_loss.promotions),
          number_to_currency(order.total),
          number_to_currency(profit_and_loss.retailer_bottle_price),
          number_to_currency(profit_and_loss.credit_card_fees),
          retailer ? number_to_currency(profit_and_loss.net_retailer_disbursements) : number_to_currency(0.00),
          order.adjustments.eligible.promotion.first.try(:label),
          order.try(:groupon_code).try(:code),
          order.state,
          order.payment_state,
          order.shipment_state,
          retailer ? retailer.name : '',
          order.ship_address ? order.ship_address.state.abbr : '',
          order.email,
          order.is_gift? ? 'Yes' : ''
        ]
      end
    end

  end

  def non_admin_report
    column_names = ["OrderNumber", "OrderDate", "AcceptedDate", "Ship-to State", "OrderState", "PaymentState", "ShipmentState", "Tax", "ProductCostForRetailer", "TotalDisbursementToRetailer"]

    CSV.generate do |csv|
      csv << column_names
      @orders.each do |order|
        csv << [	order.number,
            (@show_only_completed ? order.completed_at : order.created_at).to_date,
            order.accepted_at.nil? ? nil : order.accepted_at.to_date,
            order.ship_address.state.abbr,
            order.state,
            order.payment_state,
            order.shipment_state,
            number_to_currency(order.tax_total),
            number_to_currency((line_items.collect {|line_item| line_item.product_cost_for_retailer }).sum),
            order.retailer ? number_to_currency(order.total_amount_due_to_retailer) : number_to_currency(0.00)
          ]
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
