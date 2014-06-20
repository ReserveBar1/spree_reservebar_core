# Insert on V.S Deluxe Edition by Shepard Fairey product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_SF_deluxe_product",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/SF_deluxe_product",
                     :disabled => false)

# Insert on V.S Limited Edition by Shepard Fairey product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_SF_limited_product",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/SF_limited_product",
                     :disabled => false)

# Insert at checkout for V.S Shepard Fairey products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_SF_checkout",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/SF_checkout",
                     :disabled => false)

# Insert at confirmation for V.S Shepard Fairey products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_SF_confirmation",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/SF_confirmation",
                     :disabled => false)
