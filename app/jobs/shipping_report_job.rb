class ShippingReportJob < Struct.new(:current_user_id, :sku)

  def perform
    ShippingReportMailer.send_report(current_user_id, sku).deliver
  end

end
