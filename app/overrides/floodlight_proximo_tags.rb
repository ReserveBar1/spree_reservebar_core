# Insert on cart page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_cart",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/cart",
                     :disabled => false)
