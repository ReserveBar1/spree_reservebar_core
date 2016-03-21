# Insert on Dom Perignon brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_dom_perignon_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/dom_perignon/brand",
  disabled: false
)

# Insert on Dom Perignon product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_dom_perignon_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/dom_perignon/products",
  disabled: false
)

# Insert on Cart page, if there are Dom Perignon products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_dom_perignon_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/dom_perignon/cart",
  disabled: false
)

# Insert on Confirmation page, if there are Dom Perignon products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_dom_perignon_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/dom_perignon/confirmation",
  disabled: false
)
