Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                     :name => "admin_orders_notes",
                     :insert_after => "[data-hook='admin_order_show_details']",
                     :partial => "spree/admin/orders/admin_notes",
                     :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/orders/_form",
                     :name => "admin_orders_notes",
                     :insert_before => "[data-hook='admin_order_form_buttons']",
                     :partial => "spree/admin/orders/edit_admin_notes",
                     :disabled => false)
