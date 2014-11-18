# Insert on Patron product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_products",
                     :insert_bottom => "body",
                     :partial => "spree/google_tags/patron/products",
                     :disabled => false)

