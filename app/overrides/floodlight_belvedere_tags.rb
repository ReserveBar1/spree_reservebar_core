# Insert on Belvedere brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_belvedere_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/belvedere/brand",
                     :disabled => false)
