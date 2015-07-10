# Insert on Moet Chandon brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_moet_chandon_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/moet_chandon/brand",
  disabled: false
)

# Insert on Moet Chandon product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_moet_chandon_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/moet_chandon/products",
  disabled: false
)

# Insert on Cart page, if there are Moet Chandon products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_moet_chandon_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/moet_chandon/cart",
  disabled: false
)
