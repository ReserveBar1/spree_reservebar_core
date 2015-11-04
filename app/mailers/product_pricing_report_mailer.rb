class ProductPricingReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default from: "noreply@reservebar.com"

  def send_report(user_id)
    user = Spree::User.find user_id

    filename = "product_pricing_report_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
    attachments[filename] = {
      mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252',
        :undef => :replace, replace: '')
    }

    mail(to: user.email, reply_to: 'noreply@reservebar.com',
      subject: 'Your Product Product report is ready',
      body: 'Please find your report attached.')
  end

  private

  def report_csv_file
    variants = Spree::Variant.where(deleted_at: nil).includes(:product, { product: :brand })
    retailers = Spree::Retailer.where(state: 'active')

    CSV.generate do |csv|
      csv << ['Product Name', 'Website Price', 'Brand', 'SKU'] + retailers.map(&:name)

      variants.each do |variant|
        row = [ variant.name, number_to_currency(variant.price), variant.product.try(:brand).try(:title), variant.sku ]
        product_costs = Spree::ProductCost.where(variant_id: variant.id)
        var_cost_prices = []
        retailers.each do |retailer|
          product_cost = product_costs.find_by_retailer_id(retailer.id)
          if product_cost.present?
            var_cost_prices << number_to_currency(product_cost.cost_price)
          else
            var_cost_prices << ''
          end
        end
        row += var_cost_prices
        csv << row
      end

    end
  end

end
