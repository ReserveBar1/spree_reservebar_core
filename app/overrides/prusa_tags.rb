# Insert on PRUSA brand page (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_glenlivet_brand_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/prusa/brand_header",
                     :disabled => false)

# Insert on PRUSA brand page (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_brand_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/prusa/brand_footer",
                     :disabled => false)

# Insert on PRUSA product pages (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_products_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/prusa/products_header",
                     :disabled => false)

# Insert on PRUSA product pages (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_products_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/prusa/products_footer",
                     :disabled => false)

# Insert on Cart page, if there are PRUSA products (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_cart_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/prusa/cart_header",
                     :disabled => false)

# Insert on Cart page, if there are PRUSA products (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_cart_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/prusa/cart_footer",
                     :disabled => false)

# Insert on Address page, if there are PRUSA products (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_address_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/prusa/address_header",
                     :disabled => false)

# Insert on Address page, if there are PRUSA products (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_address_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/prusa/address_footer",
                     :disabled => false)

# Insert on Confirmation page, if there are PRUSA products (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_confirmation_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/prusa/confirmation_header",
                     :disabled => false)

# Insert on Confirmation page, if there are PRUSA products (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "tags_prusa_confirmation_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/prusa/confirmation_footer",
                     :disabled => false)
