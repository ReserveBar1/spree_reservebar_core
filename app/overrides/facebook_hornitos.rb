# Insert on Hornitos brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_brand",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/brand",
                     :disabled => true)

# Insert on Hornitos product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_products",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/products",
                     :disabled => true)

# Insert on Cart page, if there are Hornitos products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_cart",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/cart",
                     :disabled => true)

# Insert on Registration page, if there are Hornitos products in order
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_registration",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/registration",
                     :disabled => true)

# Insert on Address page, if there are Hornitos products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_address",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/address",
                     :disabled => true)

# Insert on Confirmation page, if there are Hornitos products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_confirmation",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/confirmation",
                     :disabled => true)
