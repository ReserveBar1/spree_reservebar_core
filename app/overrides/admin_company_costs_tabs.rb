Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "company_costs_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:company_costs, :url => spree.admin_company_costs_path) %>",
                     :disabled => false)
