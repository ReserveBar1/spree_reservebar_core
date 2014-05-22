# Insert on MAESTRO DOBEL® product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_dobel_product",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/dobel_product",
                     :disabled => false)

# Insert on Jose Cuervo® Reserva de la Familia® product page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_proximo_rdlf_product",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/proximo/rdlf_product",
                     :disabled => false)
