# Insert on VEEV brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_veev_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/veev/brand",
                     :disabled => false)

# Insert on Glenmorangie product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_veev_products",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/veev/products",
                     :disabled => false)

# Insert on Confirmation page, if there are VEEV products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_veev_confirmation",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/veev/confirmation",
                     :disabled => false)
