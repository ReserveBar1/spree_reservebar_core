class ProductDetailsReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::NumberHelper

  default from: 'noreply@reservebar.com'

  def send_report(user_id)
    user = Spree::User.find user_id
    @variants = Spree::Variant.where(deleted_at: nil).includes(:product,
      { product: :shipping_category }, { product: :brand },
      { product: { brand: :brand_owner } })

    filename = "product_details_report_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
    attachments[filename] = {
      mime_type: 'text/csv',
      content: report_csv_file.encode('WINDOWS-1252',
        :undef => :replace, replace: '')
    }

    mail(to: user.email, reply_to: 'noreply@reservebar.com',
      subject: 'Your Product Details report is ready',
      body: 'Please find your report attached.')
  end

  private

  def report_csv_file
    column_names = [
      'Product Name',
      'Master Price',
      'Available on',
      'SKU',
      'Weight',
      'Height',
      'Width',
      'Depth',
      'Shipping Category',
      'Tax Category',
      'Brand Owner',
      'Brand',
      'Partner',
      'State Blacklist'
    ]

    CSV.generate do |csv|
      csv << column_names

      @variants.each do |var|
        available_on = var.product.try(:available_on)
        partner_id = var.product.try(:partner_id)

        csv << [
          var.product.try(:name),
          number_to_currency(var.price),
          available_on.present? ? available_on.strftime('%Y-%m-%d') : nil,
          var.sku,
          var.weight.to_f,
          var.height.to_f,
          var.width.to_f,
          var.depth.to_f,
          var.product.try(:shipping_category).try(:name),
          var.product.try(:tax_category).try(:name),
          var.product.try(:brand).try(:brand_owner).try(:title),
          var.product.try(:brand).try(:title),
          partner_id.present? ? Partner.find(partner_id).name : nil,
          var.product.try(:state_blacklist)
        ]
      end
    end
  end
end
