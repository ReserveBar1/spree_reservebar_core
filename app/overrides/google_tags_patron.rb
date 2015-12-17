# Insert on Patron brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_brand",
                     :insert_bottom => "body",
                     :partial => "spree/google_tags/patron/brand",
                     :disabled => true)

# Insert on Patron product pages
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_products",
                     :insert_bottom => "body",
                     :partial => "spree/google_tags/patron/products",
                     :disabled => true)

# Insert on Cart page, if there are Patron products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_cart",
                     :insert_top => "body",
                     :partial => "spree/google_tags/patron/cart",
                     :disabled => true)

# Insert on Confirmation page, if there are Patron products
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "google_patron_confirmation",
                     :insert_top => "body",
                     :partial => "spree/google_tags/patron/confirmation",
                     :disabled => true)
