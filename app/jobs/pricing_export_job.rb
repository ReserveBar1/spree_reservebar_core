class PricingExportJob < Struct.new(:current_user, :params)

  def perform
    @product = Spree::Product.includes(:variants_including_master => [:product_costs]).find_by_permalink(params['product_id'])
    @product_costs = @product.variants_including_master.map(&:product_costs).flatten
    ProductPricingReportMailer.send_report(@product_costs, current_user).deliver
  end

end
