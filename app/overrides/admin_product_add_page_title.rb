Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "admin_products_page_title",
                     :insert_before => "code[erb-loud]:contains('field_container :description')",
                     :partial => "spree/admin/products/page_title",
                     :disabled => false)
