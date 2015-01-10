Deface::Override.new(:virtual_path => "spree/checkout/edit",
                     :name => "christmas_delivery",
                     :insert_after => "code[erb-loud]:contains('checkout_form_')",
                     :partial => 'spree/checkout/christmas_delivery',
                     :disabled => true)
