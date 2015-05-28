# Insert on Absolut brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/brand",
  disabled: false
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_brand",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/brand",
  disabled: false
)

# Insert on OAK by Absolut product page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_product",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/product",
  disabled: false
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_product",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/product",
  disabled: false
)

# Insert on Cart page, if there are OAK by Absolut products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_oak_by_absolut_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/oak_by_absolut/cart",
  disabled: false
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_oak_by_absolut_cart",
  insert_top: "head",
  partial: "spree/facebook_tags/oak_by_absolut/cart",
  disabled: false
)