# Insert on cart page
# Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
#                      :name => "googletags_cart",
#                      :insert_top => "body",
#                      :partial => "spree/google_tags/cart",
#                      :disabled => false)

# Insert on order summary page 
# Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
#                      :name => "googletags_order_summary",
#                      :insert_top => "body",
#                      :partial => "spree/google_tags/orders_show",
#                      :disabled => false)
                   
# Insert on taxon page - taxon dependency is handled in the partial
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "googletags_taxon_show",
                     :insert_top => "body",
                     :partial => "spree/google_tags/taxon_show",
                     :disabled => false)

# Insert on product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "googletags_product_show",
                     :insert_top => "body",
                     :partial => "spree/google_tags/product_show",
                     :disabled => false)
