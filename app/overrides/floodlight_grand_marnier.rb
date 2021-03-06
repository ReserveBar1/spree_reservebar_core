# Insert on Grand Marnier brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/brand",
  disabled: false
)

# Insert on Grand Marnier product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/products",
  disabled: false
)

# Insert on Grand Marnier ALL product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_all_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/all_products",
  disabled: false
)

# Insert on Cart page, if there are Grand Marnier products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/cart",
  disabled: false
)

# Insert on Address page, if there are Grand Marnier products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/address",
  disabled: false
)

# Insert on Confirmation page, if there are Grand Marnier products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/confirmation",
  disabled: false
)
