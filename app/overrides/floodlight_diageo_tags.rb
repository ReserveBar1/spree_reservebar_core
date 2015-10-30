# Insert on cart page
# Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
#                      :name => "floodlight_diageo_cart",
#                      :insert_top => "body",
#                      :partial => "spree/floodlight_tags/diageo/cart",
#                      :disabled => false)

# Insert on order summary page 
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_diageo_order_summary",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/diageo/orders_show",
                     :disabled => true)
                   
# Insert on taxon page - taxon dependency is handled in the partial
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_diageo_taxon_show",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/diageo/taxon_show",
                     :disabled => true)

# Insert on product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_diageo_product_show",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/diageo/product_show",
                     :disabled => true)
