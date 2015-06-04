# Insert on Cruzan pages (logic in tag itself)
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_cruzan",
  insert_top: "body",
  partial: "spree/floodlight_tags/cruzan_tag",
  disabled: false
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_cruzan",
  insert_top: "head",
  partial: "spree/facebook_tags/cruzan_tag",
  disabled: false
)
