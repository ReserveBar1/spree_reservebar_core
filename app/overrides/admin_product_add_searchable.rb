Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "admin_products_searchable",
                     :insert_top => "[data-hook='admin_product_form_right']",
                     :partial => "spree/admin/products/searchable",
                     :disabled => false)
