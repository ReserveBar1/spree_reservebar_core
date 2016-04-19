# Insert on Maestro Dobel brand page
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_maestro_dobel_brand",
  insert_top: "body",
  partial: "spree/floodlight_tags/maestro_dobel/brand",
  disabled: false
)

# Insert on Maestro Dobel product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_maestro_dobel_products",
  insert_top: "body",
  partial: "spree/floodlight_tags/maestro_dobel/products",
  disabled: false
)

# Insert on Cart page, if there are Maestro Dobel products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_maestro_dobel_cart",
  insert_top: "body",
  partial: "spree/floodlight_tags/maestro_dobel/cart",
  disabled: false
)

# Insert on Address page, if there are Maestro Dobel products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_maestro_dobel_address",
  insert_top: "body",
  partial: "spree/floodlight_tags/maestro_dobel/address",
  disabled: false
)

# Insert on Confirmation page, if there are Maestro Dobel products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "floodlight_maestro_dobel_confirmation",
  insert_top: "body",
  partial: "spree/floodlight_tags/maestro_dobel/confirmation",
  disabled: false
)
