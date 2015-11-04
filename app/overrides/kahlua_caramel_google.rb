# Insert on Confirmation page, if there are Kahlúa Salted Caramel products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "google_kahlua_salted_caramel_confirmation",
  insert_top: "body",
  partial: "spree/google_tags/kahlua_salted_caramel",
  disabled: false
)
