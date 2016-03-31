Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",                     
  name: "sia_adroll_tags",                     
  insert_bottom: "body",                     
  partial: "spree/other_tags/sia/adroll",                     
  disabled: false
)

Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "sia_fb_google_tags",
  insert_bottom: "head",
  partial: "spree/other_tags/sia/fb_google",
  disabled: false
)
