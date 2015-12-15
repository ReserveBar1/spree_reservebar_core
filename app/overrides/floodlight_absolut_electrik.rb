# Insert on Absolut Electrik product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/products",
  disabled: false
)

# Insert on Cart page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/cart",
  disabled: false
)

# Insert on Address page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/address",
  disabled: false
)

# Insert on Confirmation page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_electrik_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_electrik/confirmation",
  disabled: false
)
