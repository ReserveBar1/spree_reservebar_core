class RetailersReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default :from => "noreply@reservebar.com"

  def send_report(order_ids, user_id)
    @current_user = Spree::User.find user_id
    @orders = Spree::Order.where(id: order_ids)
    @orders.each do |order|
      order.build_profit_and_loss if order.profit_and_loss.nil?
    end

    filename = "retailer_report_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
    attachments[filename] = {
      mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252',
        :undef => :replace, replace: '')
    }

    mail(to: @current_user.email, reply_to: "noreply@reservebar.com",
      subject: "Your Retailer report is ready")
  end

  private

  def report_csv_file
    column_names = ["Order Number",
                    "Order Date",
                    "Retailer Name",
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
        prices_array = prices_array.map { |p| number_to_currency(p) } if prices_array.present?

        csv << [order.number,
                (order.completed_at.nil? ? order.created_at : order.completed_at).to_date,
                order.try(:retailer).try(:name),
                order.accepted_at.nil? ? nil : order.accepted_at.to_date,
                names_array.empty? ? nil : strip_tags(names_array.join('|')).gsub(/&quot;|,/, ''),
                order.number_of_bottles,
                prices_array.empty? ? nil : prices_array.join('|'),
                number_to_currency(order.profit_and_loss.total_bottle_price),
                number_to_currency(order.profit_and_loss.gift_packaging_charge),
                number_to_currency(order.profit_and_loss.shipping_costs),
                number_to_currency(order.profit_and_loss.state_fulfillment_fee),
                number_to_currency(order.profit_and_loss.sales_tax),
                number_to_currency(order.profit_and_loss.promotions),
                number_to_currency(order.total),
                number_to_currency(order.profit_and_loss.retailer_bottle_price),
                number_to_currency(order.profit_and_loss.credit_card_fees),
                order.retailer ? number_to_currency(order.profit_and_loss.net_retailer_disbursements) : number_to_currency(0),
              ]
      end
    end
  end

end
