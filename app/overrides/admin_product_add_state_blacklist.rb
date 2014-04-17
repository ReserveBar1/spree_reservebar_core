Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "admin_products_state_blacklist",
                     :insert_bottom => "[data-hook='admin_product_form_right']",
                     :sequence => {:after => "admin_products_shipping_surcharge"}, 
                     :partial => "spree/admin/products/state_blacklist",
                     :disabled => false)
