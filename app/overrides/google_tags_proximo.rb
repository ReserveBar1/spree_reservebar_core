# Insert on Proximo brand pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_proximo_brand",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/brand",
                     :disabled => false)

# Insert on Proximo product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_proximo_products",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/products",
                     :disabled => false)

# Insert on Cart page, if there are Proximo products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_proximo_cart",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/cart",
                     :disabled => false)

# Insert on Address page, if there are Proximo products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_proximo_address",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/address",
                     :disabled => false)

# Insert on Confirmation page, if there are Proximo products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_proximo_confirmation",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/confirmation",
                     :disabled => false)
