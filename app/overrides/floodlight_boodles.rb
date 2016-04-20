# Insert on Boodles brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_boodles_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/boodles/brand",
  disabled: false
)

# Insert on Boodles product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_boodles_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/boodles/products",
  disabled: false
)

# Insert on Cart page, if there are Boodles products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_boodles_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/boodles/cart",
  disabled: false
)

# Insert on Address page, if there are Boodles products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_boodles_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/boodles/address",
  disabled: false
)

# Insert on Confirmation page, if there are Boodles products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_boodles_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/boodles/confirmation",
  disabled: false
)
