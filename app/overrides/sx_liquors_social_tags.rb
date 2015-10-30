# Insert on SX Liquors Confirmation page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "social_sx_liquors_confirmation",
  insert_top: "body",
  partial: "spree/other_tags/sx_liquors_social_tags",
  disabled: true
)
