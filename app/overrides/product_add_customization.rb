# Add UI to cart
Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                     :name => "product_add_customization",
                     :original => 'bcaf73e20d7166bda282a42437de41b008c928c5',
                     :insert_top => "[data-hook='inside_product_cart_form']",
                     :partial => "spree/products/customization",
                     :disabled => false)

# Show on order confirmation page with line item
Deface::Override.new(:virtual_path => "spree/shared/_order_details",
                     :name => "cart_add_customization",
                     :original => 'd9e86fbc123a5ea321c3bb91060c44dd12d6bcbd',
                     :insert_bottom => "[data-hook='order_item_description']",
                     :partial => "spree/orders/customization_show",
                     #:sequence => {:after => "cart_remove_item_description"},
                     :disabled => false)

# Show on admin order show with line item
Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                     :name => "admin_orders_add_custom_engraving_notice",
                     :original => 'a9f815cd6d4a3ac5bd4550329ff0d6f9c985c6da',
                     :insert_top => "[data-hook='admin_order_show_details']",
                     :partial => "/spree/admin/orders/customization",
                     :disabled => false)

# Show on admin order edit with line item
Deface::Override.new(:virtual_path => "spree/admin/orders/edit",
                     :name => "admin_orders_edit_add_custom_engraving_info",
                     :original => '792aeeb8d64104c36a48a17883d26a63b28b8e21',
                     :insert_top => "[data-hook='admin_order_edit_form']",
                     :partial => "/spree/admin/orders/update_engraving_text",
                     :disabled => false)
