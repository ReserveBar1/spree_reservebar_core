class ProductPricingReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default :from => "noreply@reservebar.com"

  def send_report(user)
    @current_user = user

    attachments["product_pricing_report.csv"] = { :mime_type => 'text/csv', :content => report_csv_file }
    mail(:to => @current_user.email, :reply_to => "noreply@reservebar.com", :subject => "Your product pricing report is ready.")
  end

  private

  def variants
    @variants ||= Spree::Product.all.collect(&:variants_including_master).flatten
  end

  def retailers
    @retailers ||= Spree::Retailer.all
  end

  def retailer_states
    retailers.map { |r| r.physical_address.state.abbr }
  end

  def retailer_names
    retailers.map(&:name)
  end

  def admin_report
    CSV.generate do |csv|
      csv << ["SKU"] + retailer_states
      csv << [" "]   + retailer_names

      variants.each do |variant|
        ary = []
        product_costs = variant.product_cost_for_retailers.map { |cost| number_to_currency(cost) }
        ary = [variant.sku] + product_costs
        csv << ary
      end
    end
  end

  def admin_user?
    @current_user.has_role?("admin")
  end

  def non_admin_report
  end

  def report_csv_file
    if admin_user?
      admin_report
    else
      non_admin_report
    end
  end

end
