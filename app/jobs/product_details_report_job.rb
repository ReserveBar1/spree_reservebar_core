class ProductDetailsReportJob < Struct.new(:current_user_id, :sku)

  def perform
    ProductDetailsReportMailer.send_report(current_user_id).deliver
  end

end
