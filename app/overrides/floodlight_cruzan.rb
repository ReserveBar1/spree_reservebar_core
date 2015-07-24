# Insert on Cruzan brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/brand",
  disabled: false
)

# Insert on Cruzan product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/products",
  disabled: false
)

# Insert on Cart page, if there are Cruzan products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/cart",
  disabled: false
)

# Insert on Address page, if there are Cruzan products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/address",
  disabled: false
)

# Insert on Confirmation page, if there are Cruzan products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/confirmation",
  disabled: false
)
