Deface::Override.new(:virtual_path => "spree/admin/product_groups/edit",
                     :name => "admin_product_groups_export_pricing_csv",
                     :insert_after => "#preview_container",
                     :partial => "/spree/admin/product_groups/pricing_export_csv",
                     :disabled => false)
