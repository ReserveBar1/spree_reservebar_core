# H250 Product Remarketing Tag (22 Apr 2015)
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "h250_remarketing_tag",
  insert_bottom: "body",
  partial: "spree/other_tags/h250_remarketing_tag",
  disabled: true
)
