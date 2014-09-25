Deface::Override.new(:virtual_path => "spree/admin/orders/edit",
                     :name => "admin_orders_change_retailer",
                     :insert_after => "[data-hook='admin_order_edit_header']",
                     :partial => "spree/admin/orders/change_retailer",
                     :disabled => false)
