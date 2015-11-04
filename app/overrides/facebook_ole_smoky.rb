# Insert on Cart page, if there are Ole Smoky products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_ole_smoky_cart",
  insert_top: "head",
  partial: "spree/facebook_tags/ole_smoky/cart",
  disabled: false
)

# Insert on Address page, if there are Ole Smoky products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_ole_smoky_address",
  insert_top: "head",
  partial: "spree/facebook_tags/ole_smoky/address",
  disabled: false
)

# Insert on Confirmation page, if there are Ole Smoky products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_ole_smoky_confirmation",
  insert_top: "head",
  partial: "spree/facebook_tags/ole_smoky/confirmation",
  disabled: false
)
