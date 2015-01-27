# Insert on Absolut pages (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "absolut_adobe_header",
                     :insert_top => "head",
                     :partial => "spree/tags/absolut/adobe/head",
                     :disabled => false)

# Insert on Absolut pages (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "absolut_adobe_footer",
                     :insert_bottom => "body",
                     :partial => "spree/tags/absolut/adobe/footer",
                     :disabled => false)
