# Insert on Herradura brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_herradura_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/herradura/brand",
  disabled: false
)

# Insert on Cart page, if there are Herradura products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_herradura_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/herradura/cart",
  disabled: false
)

# Insert on Address page, if there are Herradura products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_herradura_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/herradura/address",
  disabled: false
)

# Insert on Confirmation page, if there are Herradura products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_herradura_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/herradura/confirmation",
  disabled: false
)
