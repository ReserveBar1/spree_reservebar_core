# Insert on Hornitos brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_brand",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/brand",
                     :disabled => false)

# Insert on Hornitos product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_hornitos_products",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/hornitos/products",
                     :disabled => false)

