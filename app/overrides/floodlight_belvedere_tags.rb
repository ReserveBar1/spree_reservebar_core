# Insert on Belvedere brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_belvedere_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/belvedere/brand",
                     :disabled => false)

# Insert on Belvedere product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_belvedere_products",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/belvedere/products",
                     :disabled => false)

# Insert on Address page, if there are Belvedere products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_belvedere_address",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/belvedere/address",
                     :disabled => false)

# Insert on Confirmation page, if there are Belvedere products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_belvedere_confirmation",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/belvedere/confirmation",
                     :disabled => false)
