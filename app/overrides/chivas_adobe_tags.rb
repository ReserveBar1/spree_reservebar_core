# Insert on Chivas pages (header)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "chivas_adobe_header",
                     :insert_top => "head",
                     :partial => "spree/tags/chivas/adobe/head",
                     :disabled => false)

# Insert on Chivas pages (footer)
Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "chivas_adobe_footer",
                     :insert_bottom => "body",
                     :partial => "spree/tags/chivas/adobe/footer",
                     :disabled => false)
