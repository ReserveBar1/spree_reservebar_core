# Insert on Jameson brand page
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "facebook_jameson_brand",
                     :insert_top => "body",
                     :partial => "spree/facebook_tags/jameson/brand",
                     :disabled => false)
