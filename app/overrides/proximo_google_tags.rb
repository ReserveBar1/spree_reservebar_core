# Insert on Proximo brand pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "googletag_proximo_brand",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/proximo_brand",
                     :disabled => false)

# Insert on Proximo product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "googletag_proximo_product",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/proximo_product",
                     :disabled => false)

# Insert on Proximo cart page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "googletag_proximo_cart",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/proximo_cart",
                     :disabled => false)

# Insert on Proximo order registration page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "googletag_proximo_registration",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/proximo_registration",
                     :disabled => false)
