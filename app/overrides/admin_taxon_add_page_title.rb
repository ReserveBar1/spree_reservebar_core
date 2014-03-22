Deface::Override.new(:virtual_path => "spree/admin/taxons/_form",
                     :name => "admin_taxons_page_title",
                     :insert_before => "code[erb-loud]:contains('field_container :permalink_part')",
                     :partial => "spree/admin/taxons/page_title",
                     :disabled => false)
