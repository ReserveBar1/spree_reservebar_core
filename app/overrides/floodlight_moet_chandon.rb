# Insert on Moet Chandon brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_moet_chandon_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/moet_chandon/brand",
  disabled: false
)
