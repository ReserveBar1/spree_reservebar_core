# Insert on Glenlivet brand page header
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenlivet_brand_header",
                     :insert_top => "head",
                     :partial => "spree/other_tags/glenlivet/brand_header",
                     :disabled => false)

# Insert on Glenlivet brand page footer
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "floodlight_glenlivet_brand_footer",
                     :insert_bottom => "body",
                     :partial => "spree/other_tags/glenlivet/brand_footer",
                     :disabled => false)

