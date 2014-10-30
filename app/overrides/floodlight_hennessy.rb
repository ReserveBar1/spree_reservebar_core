# Insert on Hennessy brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/brand",
                     :disabled => false)

# Insert on Hennessy product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_products",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/products",
                     :disabled => false)

# Insert on Cart page, if there are Hennessy products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_cart",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/cart",
                     :disabled => false)

# Insert on Address page, if there are Hennessy products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_address",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/address",
                     :disabled => false)

# Insert on Confirmation page, if there are Hennessy products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_hennessy_confirmation",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/hennessy/confirmation",
                     :disabled => false)
