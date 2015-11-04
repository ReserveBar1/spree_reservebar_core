# Insert on Jameson brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_jameson_brand",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/jameson/brand",
                     :disabled => true)

# Insert on Cart page, if there are Jameson products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_jameson_cart",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/jameson/cart",
                     :disabled => true)

# Insert on Confirmation page, if there are Jameson products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_jameson_confirmation",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/jameson/confirmation",
                     :disabled => true)
