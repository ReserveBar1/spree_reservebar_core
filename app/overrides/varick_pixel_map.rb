# New Varick Retargeting Pixel Map (21 Apr 2015)
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "varick_pixel_map",
  insert_top: "body",
  partial: "spree/other_tags/varick_pixels/pixel_map",
  disabled: false
)
