# encoding: utf-8

VARICK_PERMALINKS = [
  'johnnie-walker-blue-custom-engraved-bottle',
  'johnnie-walker-blue-label-brooks-brothers',
  'hennessy-250',
  'hennessy-250-collectors-blend-custom-engraved-bottle',
  'hennessy-vs',
  'hennessy-black',
  'hennessy-privilege',
  'hennessy-x-dot-o',
  'hennessy-xo-custom-engraved-bottle',
  'hennessy-paradis-1',
  'hennessy-paradis-custom-engraved-bottle',
  'hennessy-paradis-imperial',
  'hennessy-paradis-imperial-custom-engraved-bottle',
  'hennessy-richard-hennessy',
  'richard-hennessy-custom-engraved-bottle',
  'johnnie-walker-blue-label',
  'guinness-1759'
]

VARICK_BRANDS = [
  'The Glenlivet',
  'Dom Pérignon',
  'Hangar 1',
  'Patrón'
]

# New Varick Retargeting Pixel Map (21 Apr 2015)
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "varick_pixel_map",
  insert_top: "body",
  partial: "spree/other_tags/varick_pixels/pixel_map",
  disabled: false
)

# Insert on Cart page, if there are Varick targeted products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "varick_pixel_map_cart",
  insert_top: "body",
  partial: "spree/other_tags/varick_pixels/cart",
  disabled: false
)

# Insert on Address page, if there are Varick targeted products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "varick_pixel_map_address",
  insert_top: "body",
  partial: "spree/other_tags/varick_pixels/address",
  disabled: false
)

# Insert on Confirmation page, if there are Varick targeted products
Deface::Override.new(
  virtual_path: "spree/layouts/spree_application",
  name: "varick_pixel_map_confirmation",
  insert_top: "body",
  partial: "spree/other_tags/varick_pixels/confirmation",
  disabled: false
)
