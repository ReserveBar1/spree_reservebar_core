Spree::ProductsController.class_eval do

  def index
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
    @products.delete_if { |p| !p.searchable? }
    
    respond_with(@products)
  end

end 
