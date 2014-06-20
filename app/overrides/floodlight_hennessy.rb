# Insert on V.S Deluxe Edition by Shepard Fairey product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_SF_deluxe_product",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/SF_deluxe_product",
                     :disabled => false)
