Deface::Override.new(:virtual_path => "spree/admin/products/pricing",
                     :name => "admin_products_export_pricing_csv",
                     :insert_after => "#listing_product_costs",
                     :partial => "/spree/admin/products/pricing_export_csv",
                     :disabled => false)
