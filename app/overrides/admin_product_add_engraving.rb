Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "admin_products_engraving",
                     :insert_bottom => "[data-hook='admin_product_form_right']",
                     :sequence => {:after => "admin_products_state_blacklist"},
                     :partial => "spree/admin/products/engraving",
                     :disabled => false)