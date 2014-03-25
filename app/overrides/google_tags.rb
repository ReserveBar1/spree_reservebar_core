# Insert on cart page
Deface::Override.new(:virtual_path => "spree/orders/edit",
	                   :name => "googletags_cart",
	                   :insert_before => "h1",
	                   :partial => "spree/google_tags/cart",
	                   :disabled => false)

# Insert on order summary page 
Deface::Override.new(:virtual_path => "spree/orders/show",
	                   :name => "googletags_order_summary",
	                   :insert_before => "#order",
	                   :partial => "spree/google_tags/orders_show",
	                   :disabled => false)
	                   
# Insert on taxon page - taxon dependency is handled in the partial
Deface::Override.new(:virtual_path => "spree/taxons/show",
	                   :name => "googletags_taxon_show",
	                   :insert_before => ".taxon-title",
	                   :partial => "spree/google_tags/taxon_show",
	                   :disabled => false)


# Insert on product page
Deface::Override.new(:virtual_path => "spree/products/show",
	                   :name => "googletags_product_show",
	                   :insert_before => ".product-title",
	                   :partial => "spree/google_tags/product_show",
	                   :disabled => false)


