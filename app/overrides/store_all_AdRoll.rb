# Insert on all pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "adroll",
  sequence: 1001, # insert after smarter pixels
  insert_bottom: "body",
  partial: "spree/shared/adroll",
  disabled: false
)
