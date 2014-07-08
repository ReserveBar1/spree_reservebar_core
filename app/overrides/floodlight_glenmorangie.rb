# Insert on Glenmorangie brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenmorangie_brand",
                     :insert_top => "body",
                     :partial => "spree/floodlight_tags/glenmorangie/brand",
                     :disabled => false)
