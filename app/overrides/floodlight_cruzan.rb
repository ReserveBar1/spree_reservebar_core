# Insert on Cruzan brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/brand",
  disabled: true
)

# Insert on Cruzan product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/products",
  disabled: true
)

# Insert on Cart page, if there are Cruzan products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/cart",
  disabled: true
)

# Insert on Address page, if there are Cruzan products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/address",
  disabled: true
)

# Insert on Confirmation page, if there are Cruzan products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan/confirmation",
  disabled: true
)
