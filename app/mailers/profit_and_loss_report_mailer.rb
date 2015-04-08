class ProfitAndLossReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default :from => "noreply@reservebar.com"

  def send_report(order_ids, user_id)
    @current_user = Spree::User.find user_id
    orders = Spree::Order.accepted.where(id: order_ids)
    @profit_and_losses = orders.each_with_object([]) do |order, ary|
      if order.profit_and_loss.present?
        ary << order.profit_and_loss
      else
        ary << order.build_profit_and_loss
      end
    end

    filename = "profit_loss_report_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
    attachments[filename] = {
      mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252',
        :undef => :replace, replace: '')
    }

    mail(to: @current_user.email, reply_to: "noreply@reservebar.com",
      subject: "Your Profit & Loss report is ready")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    CSV.generate do |csv|
      csv << [ "Total Bottle Price"              , number_to_currency(@profit_and_losses.collect(&:total_bottle_price).sum) ]
      csv << [ "Gift Packaging Price"                  , number_to_currency(@profit_and_losses.collect(&:gift_packaging_charge).sum) ]
      csv << [ "Shipping Price"                        , number_to_currency(@profit_and_losses.collect(&:shipping_charge).sum) ]
      csv << [ "State Fulfillment Fee"           , number_to_currency(@profit_and_losses.collect(&:state_fulfillment_fee).sum) ]
      csv << [ "Sales Tax"                       , number_to_currency(@profit_and_losses.collect(&:sales_tax).sum) ]
      csv << [ "Gross Proceeds Before Promotion" , number_to_currency(@profit_and_losses.collect(&:gross_proceeds_before_promotion).sum) ]
      csv << []
      csv << [ "Retailer Bottle Price"           , number_to_currency(@profit_and_losses.collect(&:retailer_bottle_price).sum) ]
      csv << [ "Sales Tax"                       , number_to_currency(@profit_and_losses.collect(&:sales_tax).sum) ]
      csv << [ "Corrugated Box Fee"              , number_to_currency(@profit_and_losses.collect(&:corrugated_box_fee).sum) ]
      csv << [ "Credit Card Fees"                , number_to_currency(@profit_and_losses.collect(&:credit_card_fees).sum) ]
      csv << [ "Net Retailer Disbursements"      , number_to_currency(@profit_and_losses.collect(&:net_retailer_disbursements).sum) ]
      csv << []
      csv << [ "Gift Packaging Cost"             , number_to_currency(@profit_and_losses.collect(&:gift_packaging_cost).sum) ]
      csv << [ "Corrugated Cost"                 , number_to_currency(@profit_and_losses.collect(&:corrugated_cost).sum) ]
      csv << [ "Total Packaging Costs"           , number_to_currency(@profit_and_losses.collect(&:total_packaging_costs).sum) ]
      csv << []
      csv << [ "Shipping Costs"                  , number_to_currency(@profit_and_losses.collect(&:shipping_costs).sum) ]
      csv << []
      csv << [ "Total Disbursements"             , number_to_currency(@profit_and_losses.collect(&:total_disbursements).sum) ]
      csv << []
      csv << [ "Net Revenues Before Promotion"   , number_to_currency(@profit_and_losses.collect(&:net_revenues_before_promotion).sum) ]
      csv << [ "Promotions"                      , number_to_currency(@profit_and_losses.collect(&:promotions).sum) ]
      csv << [ "Net Revenues After Promotion"    , number_to_currency(@profit_and_losses.collect(&:net_revenues_after_promotion).sum) ]
    end
  end

  def report_csv_file
    if admin_user?
      admin_report
    end
  end

end
