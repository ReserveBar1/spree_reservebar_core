# Listrak Framework
Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'listrak_framework',
  insert_bottom: 'body',
  partial: 'spree/listrak/framework',
  sequence: 9999, # done last
  disabled: false
)
