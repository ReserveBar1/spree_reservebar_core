# Insert on Proximo brand pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_proximo_brand",
                     :insert_top => "body",
                     :partial => "spree/google_tags/proximo/brand",
                     :disabled => false)
