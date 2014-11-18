# Insert on Patron brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_brand",
                     :insert_bottom => "body",
                     :partial => "spree/google_tags/patron/brand",
                     :disabled => false)

# Insert on Patron product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_products",
                     :insert_bottom => "body",
                     :partial => "spree/google_tags/patron/products",
                     :disabled => false)
