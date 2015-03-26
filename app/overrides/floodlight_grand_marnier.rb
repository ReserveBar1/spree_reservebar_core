# Insert on Grand Marnier brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_grand_marnier_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/grand_marnier/brand",
                     :disabled => false)
