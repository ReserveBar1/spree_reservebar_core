# Insert on Glenlivet brand page (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_brand_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/glenlivet/brand_header",
                     :disabled => false)

# Insert on Glenlivet brand page (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_brand_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/glenlivet/brand_footer",
                     :disabled => false)

# Insert on Glenlivet product pages (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_products_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/glenlivet/products_header",
                     :disabled => false)

# Insert on Glenlivet product pages (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_products_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/glenlivet/products_footer",
                     :disabled => false)

# Insert on Cart page, if there are Glenlivet products (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_cart_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/glenlivet/cart_header",
                     :disabled => false)

# Insert on Cart page, if there are Glenlivet products (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_cart_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/glenlivet/cart_footer",
                     :disabled => false)

# Insert on Address page, if there are Glenlivet products (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_address_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/glenlivet/address_header",
                     :disabled => false)

# Insert on Address page, if there are Glenlivet products (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_address_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/glenlivet/address_footer",
                     :disabled => false)

# Insert on Confirmation page, if there are Glenlivet products (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_confirmation_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/glenlivet/confirmation_header",
                     :disabled => false)

# Insert on Confirmation page, if there are Glenlivet products (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_confirmation_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/glenlivet/confirmation_footer",
                     :disabled => false)