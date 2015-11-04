# Insert on Grand Marnier brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/brand",
  disabled: true
)

# Insert on Grand Marnier product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/products",
  disabled: true
)

# Insert on Grand Marnier ALL product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_all_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/all_products",
  disabled: true
)

# Insert on Cart page, if there are Grand Marnier products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/cart",
  disabled: true
)

# Insert on Address page, if there are Grand Marnier products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/address",
  disabled: true
)

# Insert on Confirmation page, if there are Grand Marnier products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_grand_marnier_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/grand_marnier/confirmation",
  disabled: true
)
