Deface::Override.new(:virtual_path => "spree/admin/orders/edit",
                     :name => "admin_orders_change_retailer",
                     :insert_bottom => "#order-form-wrapper",
                     :partial => "spree/admin/orders/force_update",
                     :disabled => false)
