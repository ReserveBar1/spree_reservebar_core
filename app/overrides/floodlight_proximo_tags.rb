# Insert on cart page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_cart",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/cart",
                     :disabled => false)

# Insert on checkout registration page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_registration",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/registration",
                     :disabled => false)

# Insert on checkout confirmation page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_confirmation",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/confirmation",
                     :disabled => false)

# Insert on MAESTRO DOBEL® page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_dobel",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/dobel",
                     :disabled => false)

# Insert on Jose Cuervo® Reserva de la Familia® page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_rdlf",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/rdlf",
                     :disabled => false)
