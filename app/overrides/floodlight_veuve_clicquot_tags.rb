# Insert on Veuve Clicquot brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_veuve_clicquot_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/veuve_clicquot/brand",
  disabled: false
)

# Insert on Veuve Clicquot product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_veuve_clicquot_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/veuve_clicquot/products",
  disabled: false
)

# Insert on Cart page, if there are Veuve Clicquot products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_veuve_clicquot_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/veuve_clicquot/cart",
  disabled: false
)

# Insert on Address page, if there are Veuve Clicquot products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_veuve_clicquot_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/veuve_clicquot/address",
  disabled: false
)

# Insert on Confirmation page, if there are Veuve Clicquot products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_veuve_clicquot_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/veuve_clicquot/confirmation",
  disabled: false
)
