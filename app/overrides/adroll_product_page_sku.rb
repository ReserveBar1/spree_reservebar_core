# Insert AdRoll product sku JS on Product pages
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "adroll_product_sku",
  insert_top: "body",
  partial: "spree/other_tags/adroll",
  disabled: false
)
