Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "brand_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:brands, :url => spree.admin_brands_path) %>",
                     :disabled => false)
