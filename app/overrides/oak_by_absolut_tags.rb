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
