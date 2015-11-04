Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'elyx_custom_background',
  insert_top: 'body',
  partial: 'spree/shared/elyx_custom_background',
  disabled: false
)
