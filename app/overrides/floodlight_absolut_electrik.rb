# Insert on Absolut Electrik product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/products",
  disabled: true
)

# Insert on Cart page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/cart",
  disabled: true
)

# Insert on Address page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/address",
  disabled: true
)

# Insert on Confirmation page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/confirmation",
  disabled: false
)
