# Insert on all pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "smarter_pixel",
  sequence: 1000,
  insert_bottom: "body",
  partial: "spree/smarter_pixel/all_pages",
  disabled: false
)
