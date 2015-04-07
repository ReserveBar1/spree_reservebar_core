class ProductWeightReportJob < Struct.new(:current_user_id, :sku)

  def perform
    ProductWeightReportMailer.send_report(current_user_id).deliver
  end

end
