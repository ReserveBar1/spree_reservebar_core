# Insert on Glenmorangie brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/brand",
                     :disabled => false)

# Insert on Glenmorangie product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_products",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/products",
                     :disabled => false)
