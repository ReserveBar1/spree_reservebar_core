# Insert on Absolut Elyx Gift Set product page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_elyx_gift_set_product",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_elyx_gift_set/product",
  disabled: false
)

# Insert on Address page, if there are any Absolut Elyx Gift Set products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_elyx_gift_set_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_elyx_gift_set/address",
  disabled: false
)

# Insert on Confirmation page, if there are any Absolut Elyx Gift Set products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_absolut_elyx_gift_set_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/absolut_elyx_gift_set/confirmation",
  disabled: false
)
