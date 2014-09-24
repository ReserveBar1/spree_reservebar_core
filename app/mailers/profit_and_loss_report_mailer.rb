class ProfitAndLossReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @profit_and_losses = orders.each_with_object([]) do |order, ary|
      if order.profit_and_loss.present?
        ary << order.profit_and_loss
      else
        ary << order.build_profit_and_loss
      end
    end
    @search_params = search_params

    attachments.inline["profit_loss_report.csv"] = report_csv_file
    mail(:to => @current_user.email, :reply_to => "noreply@reservebar.com", :subject => "Your profit/loss total report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    CSV.generate do |csv|
      csv << [ "Total Bottle Price", @profit_and_losses.collect(&:total_bottle_price).sum ]
      csv << [ "Gift Packaging", @profit_and_losses.collect(&:gift_packaging_charge).sum ]
      csv << [ "Shipping", @profit_and_losses.collect(&:shipping_charge).sum ]
      csv << [ "State Fulfillment Fee", @profit_and_losses.collect(&:state_fulfillment_fee).sum ]
      csv << [ "Sales Tax", @profit_and_losses.collect(&:sales_tax).sum ]
      csv << [ "Gross Proceeds Before Promotion", @profit_and_losses.collect(&:gross_proceeds_before_promotion).sum ]
      csv << []
      csv << [ "Retailer Bottle Price", @profit_and_losses.collect(&:retailer_bottle_price).sum ]
      csv << [ "Sales Tax", @profit_and_losses.collect(&:sales_tax).sum ]
      csv << [ "Corrugated Box Fee", @profit_and_losses.collect(&:corrugated_box_fee).sum ]
      csv << [ "Credit Card Fees", @profit_and_losses.collect(&:credit_card_fees).sum ]
      csv << [ "Net Retailer Disbursements", @profit_and_losses.collect(&:net_retailer_disbursements).sum ]
      csv << []
      csv << [ "Gift Packaging Cost", @profit_and_losses.collect(&:gift_packaging_cost).sum ]
      csv << [ "Corrugated Cost", @profit_and_losses.collect(&:corrugated_cost).sum ]
      csv << [ "Total Packaging Costs", @profit_and_losses.collect(&:total_packaging_costs).sum ]
      csv << []
      csv << [ "Shipping Costs", @profit_and_losses.collect(&:shipping_costs).sum ]
      csv << []
      csv << [ "Total Disbursements", @profit_and_losses.collect(&:total_disbursements).sum ]
      csv << []
      csv << [ "Net Revenues Before Promotion", @profit_and_losses.collect(&:net_revenues_before_promotion).sum ]
      csv << [ "Promotions", @profit_and_losses.collect(&:promotions).sum ]
      csv << [ "Net Revenues After Promotion", @profit_and_losses.collect(&:net_revenues_after_promotion).sum ]
    end
  end

  def report_csv_file
    if admin_user?
      admin_report
    end
  end

end
