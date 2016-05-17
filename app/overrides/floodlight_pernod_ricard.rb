# Insert on Product page, if there are Avion products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_pernod_ricard_avion",
  insert_top: "body",
  partial: "spree/floodlight_tags/pernod_ricard/avion",
  disabled: false
)

# Insert on Product page, if there are Chivas products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_pernod_ricard_chivas",
  insert_top: "body",
  partial: "spree/floodlight_tags/pernod_ricard/chivas",
  disabled: false
)

# Insert on Confirmation page, if there are Pernod Ricard products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_pernod_ricard_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/pernod_ricard/confirmation",
  disabled: false
)
