# Insert on OAK by Absolut product page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_product",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/product",
  disabled: true
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_product",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/product",
  disabled: true
)

# Insert on Cart page, if there are OAK by Absolut products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/cart",
  disabled: true
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_cart",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/cart",
  disabled: true
)

# Insert on Address page, if there are OAK by Absolut products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/address",
  disabled: true
)
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_address",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/address",
  disabled: true
)

# Insert on Confirmation page, if there are OAK by Absolut products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/confirmation",
  disabled: true
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_confirmation",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/confirmation",
  disabled: true
)
