Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'pages_custom_background',
  insert_top: 'body',
  partial: 'spree/shared/pages_custom_background',
  disabled: false
)
