Spree::Core::Engine.routes.prepend do

  # For paginated taxons
  match '/t/*id/page/:page', :to => 'taxons#show', :as => :nested_taxons

  # Routes for business gift white glove service
  resources :business_giftings
  get '/business_gifting', :to => 'business_giftings#new', :as => :business_gifting


  # route to allow applying a coupon during checkout via Ajax
  match '/checkout/apply_coupon/:state' => 'checkout#apply_coupon', :as => :apply_coupon_checkout

  # age gate routes
  match '/age_gate/validate_age' => 'age_gate#validate_age', :as => :age_gate_validate_age

  namespace :admin do

    match 'test/test' => "test#test"

    resources :business_giftings

    resources :age_gates
    resources :counties

    resources :products do
      get :routes
      get :edit_routes
      put :update_routes

      get :pricing, :as => :pricing
      get :pricing_export, :as => :pricing_export
    end

    resources :product_groups do
      # get :pricing, :as => :pricing
      get :pricing_export, :as => :pricing_exports
    end

    match '/get_retailer_data' => 'overview#get_retailer_data'
    match '/orders/get_retailer_data' => 'orders#get_retailer_data'

    match '/orders/:order_id/line_items/:id/update_engraving_text/' => 'line_items#update_engraving_text', :as => :update_engraving_text

    resources :retailers do
      get :activate
      get :suspend
      put :update_shipping
      resources :product_costs do
        collection { post :import }
      end
      get :regular_reminder_email
      get :counties
      put :update_counties
      get :shipping_methods
      put :update_shipping_methods
    end

    resources :brands

    resources :company_costs

    resources :orders do
      member do
      	get :order_complete
      	get :accept
      	get :confirm_email
      	get :giftor_delivered_email
      	get :giftee_notify_email
      	get :giftee_shipped_email
      	get :giftor_shipped_email
      	get :retailer_submitted_email
      	get :retailer_canceled_email
      	get :summary
        post :update_retailer
      end
      resources :shipments do
        resources :shipment_details do
          post :create
          get  :print_label
        end
      end
      resources :gifts do
        get :print_card
      end
      collection do
      	get :regular_reminder_email
      	get :export
      end
    end

    resources :users do
      collection do
        get :export
      end
    end

    # Add a route to print a test label for the shipping methods
    resources :shipping_methods do
      get :print_test_label
    end

    resources :reports, :only => [:index, :show] do  # <= add this block
      collection do
        get :sales_total
        post :sales_total
        get :product_pricing
        post :product_pricing
        get :product_group_pricing
        post :product_group_pricing
        get :product_weight
        get :shipping_guinness
        get :shipping_veu_clic_clutch
        get :shipping_veu_clic_travel_case
      end
    end

  end
end
