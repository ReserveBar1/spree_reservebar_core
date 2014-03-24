Spree::ProductsController.class_eval do

  private

  def accurate_title
    if @product
      unless @product.page_title?
        return "#{@product.name}, buy or gift. #{default_title}"
      else
        return @product.page_title
      end
    end
  end

end
