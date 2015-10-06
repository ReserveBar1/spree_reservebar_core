# Insert on Absolut Electrik custom pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_absolut_electrik_custom_pages",
  insert_top: "head",
  partial: "spree/facebook_tags/absolut_electrik/custom_pages",
  disabled: false
)

# Insert on Absolut Electrik product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_absolut_electrik_products",
  insert_top: "head",
  partial: "spree/facebook_tags/absolut_electrik/products",
  disabled: false
)

# Insert on Cart page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_absolut_electrik_cart",
  insert_top: "head",
  partial: "spree/facebook_tags/absolut_electrik/cart",
  disabled: false
)

# Insert on Address page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_absolut_electrik_address",
  insert_top: "head",
  partial: "spree/facebook_tags/absolut_electrik/address",
  disabled: false
)

# Insert on Confirmation page, if there are Absolut Electrik products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "facebook_absolut_electrik_confirmation",
  insert_top: "head",
  partial: "spree/facebook_tags/absolut_electrik/confirmation",
  disabled: false
)
