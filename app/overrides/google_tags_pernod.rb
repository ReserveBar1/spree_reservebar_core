# Insert on Confirmation page, if there are Aberlour products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "google_aberlour_confirmation",
  insert_top: "body",
  partial: "spree/google_tags/aberlour/confirmation",
  disabled: false
)

# Insert on Confirmation page, if there are Absolut products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "google_absolut_confirmation",
  insert_top: "body",
  partial: "spree/google_tags/absolut/confirmation",
  disabled: false
)

# Insert on Confirmation page, if there are OAK by Absolut products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "google_oak_by_absolut_confirmation",
  insert_top: "body",
  partial: "spree/google_tags/oak_by_absolut/confirmation",
  disabled: false
)
