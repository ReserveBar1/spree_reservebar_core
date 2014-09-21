class RetailersReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @orders = orders
    @orders.each do |order|
      order.build_profit_and_loss if order.profit_and_loss.nil?
    end
    @search_params = search_params

    attachments.inline["retailer_orders_report.csv"] = report_csv_file
    mail(:to => @current_user.email, :content_type => "multipart/mixed", :reply_to => "noreply@reservebar.com", :subject => "Your orders report is ready.")
  end

  private

  def report_csv_file
    column_names = ["Order Number",
                    "Order Date",
                    "Accepted Date",
                    "Product Name",
                    "Number of Bottles",
                    "Website Product Price",
                    "Total Bottle Price",
                    "Gift Packaging Price",
                    "Shipping Cost",
                    "State Fulfillment Fee",
                    "Tax",
                    "Promo discount($)",
                    "Website Order Total",
                    "Price paid to retailer net of RB Advertising fees",
                    "Credit Card Fees",
                    "Total Remittance to Retailer"
                   ]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        names_array = order.line_items.map{|line_item|line_item.product.try(:name)}.compact
        prices_array = order.line_items.map{|line_item|line_item.price}.compact

        csv << [order.number,
                (order.completed_at.nil? ? order.created_at : order.completed_at).to_date,
                order.accepted_at.nil? ? nil : order.accepted_at.to_date,
                names_array.empty? ? nil : strip_tags(names_array.join('|')).gsub(/&quot;|,/, ''),
                order.number_of_bottles,
                prices_array.empty? ? nil : prices_array.join('|'),
                order.profit_and_loss.total_bottle_price,
                order.profit_and_loss.gift_packaging_charge,
                order.profit_and_loss.shipping_costs,
                order.profit_and_loss.state_fulfillment_fee,
                order.profit_and_loss.sales_tax,
                order.profit_and_loss.promotions,
                order.total,
                order.profit_and_loss.retailer_bottle_price,
                order.profit_and_loss.credit_card_fees,
                order.retailer ? order.profit_and_loss.net_retailer_disbursements : 0,
              ]
      end
    end
  end

end
