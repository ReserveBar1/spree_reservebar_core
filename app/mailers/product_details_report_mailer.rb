class ProductDetailsReportMailer < ActionMailer::Base
  default from: 'noreply@reservebar.com'

  def send_report(user_id)
    user = Spree::User.find user_id
    @variants = Spree::Variant.where(deleted_at: nil).includes(:product,
      { product: :brand }, { product: { brand: :brand_owner } })

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
    column_names = [ 'Brand Owner', 'Brand Name', 'Product Name',
      'SKU','Weight' ]

    CSV.generate do |csv|
      csv << column_names

      @variants.each do |var|
        csv << [
          var.product.try(:brand).try(:brand_owner).try(:title),
          var.product.try(:brand).try(:title),
          var.product.try(:name),
          var.sku,
          var.weight
        ]
      end
    end
  end
end
