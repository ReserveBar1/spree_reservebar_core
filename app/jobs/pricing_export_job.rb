class PricingExportJob < Struct.new(:current_user, :params)

  def perform
    @product_costs = product_costs
    ProductPricingReportMailer.send_report(@product_costs, current_user).deliver
  end

  def product_costs
    if params['product_id'].present?
      @product = Spree::Product.includes(:variants_including_master => [:product_costs]).find_by_permalink(params['product_id'])
      @product_costs = @product.product_costs
    elsif params['product_group_id']
      @product_group = Spree::ProductGroup.find_by_permalink(params['product_group_id'])
      @product_costs = @product_group.products.map(&:product_costs).flatten
    end

    @product_costs
  end

end
