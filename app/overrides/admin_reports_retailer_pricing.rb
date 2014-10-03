Deface::Override.new(:virtual_path => "spree/admin/reports/index",
                     :name => "admin_reports_retailer_pricing",
                     :insert_bottom => "table tbody",
                     :partial => "/spree/admin/reports/retailer_pricing",
                     :disabled => false)
