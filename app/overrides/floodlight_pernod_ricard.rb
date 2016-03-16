# Insert on Confirmation page, if there are Pernod Ricard products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_pernod_ricard_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/pernod_ricard/confirmation",
  disabled: false
)
