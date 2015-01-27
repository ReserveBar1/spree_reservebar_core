# Insert on Jameson pages (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "jameson_adobe_header",
                     :insert_top => "head",
                     :partial => "spree/tags/jameson/adobe/head",
                     :disabled => false)

# Insert on Jameson pages (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "jameson_adobe_footer",
                     :insert_bottom => "body",
                     :partial => "spree/tags/jameson/adobe/footer",
                     :disabled => false)
