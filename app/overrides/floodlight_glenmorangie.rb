# Insert on Glenmorangie brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/brand",
                     :disabled => true)

# Insert on Glenmorangie product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_products",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/products",
                     :disabled => true)

# Insert on Cart page, if there are Glenmorangie products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_cart",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/cart",
                     :disabled => true)

# Insert on Address page, if there are Glenmorangie products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_address",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/address",
                     :disabled => true)

# Insert on Confirmation page, if there are Glenmorangie products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_confirmation",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/confirmation",
                     :disabled => true)
