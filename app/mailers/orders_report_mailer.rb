class OrdersReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @orders = orders
    @orders.each do |order|
      order.build_profit_and_loss if order.profit_and_loss.nil?
    end
    @search_params = search_params

    attachments.inline["orders_report.csv"] = { :mime_type => 'text/csv', :content => report_csv_file }
    mail(:to => @current_user.email, :reply_to => "noreply@reservebar.com", :subject => "Your orders report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = ["Order Number",
                    "Order Date",
                    "Accepted Date",
                    "Product Name",
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
                    "Order Status",
                    "Payment Status",
                    "Shipment Status",
                    "Retailer",
                    "Ship-to State",
                    "Customer email address"]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        names_array = order.line_items.map{|line_item|line_item.product.try(:name)}.compact
        prices_array = order.line_items.map{|line_item|line_item.price}.compact
        shipping_charge_uplift = order.shipping_method.calculator.preferred_uplift rescue 0.0

        csv << [order.number,
                (order.completed_at.nil? ? order.created_at : order.completed_at).to_date,
                order.accepted_at.nil? ? nil : order.accepted_at.to_date,
                names_array.empty? ? nil : strip_tags(names_array.join('|')).gsub(/&quot;|,/, ''),
                order.number_of_bottles,
                prices_array.empty? ? nil : prices_array.join('|'),
                order.profit_and_loss.total_bottle_price,
                order.profit_and_loss.gift_packaging_charge,
                order.profit_and_loss.gift_packaging_cost,
                order.profit_and_loss.corrugated_cost,
                order.profit_and_loss.shipping_costs,
                order.profit_and_loss.state_fulfillment_fee,
                order.profit_and_loss.sales_tax,
                order.profit_and_loss.promotions,
                order.total,
                order.profit_and_loss.retailer_bottle_price,
                order.profit_and_loss.credit_card_fees,
                order.retailer ? order.profit_and_loss.net_retailer_disbursements : 0,
                order.adjustments.eligible.promotion.first.try(:label),
                order.state,
                order.payment_state,
                order.shipment_state,
                order.retailer ? order.retailer.name : '',
                order.ship_address ? order.ship_address.state.abbr : '',
                order.email
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
            order.tax_total,
            (order.line_items.collect {|line_item| line_item.product_cost_for_retailer }).sum,
            order.retailer ? order.total_amount_due_to_retailer : 0
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
