# Listrak Framework
Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'listrak_framework',
  insert_bottom: 'body',
  partial: 'spree/listrak/framework',
  sequence: 9999, # done last
  disabled: false
)

# Listrak Order Confirmation
Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'listrak_order_confirmation',
  insert_top: 'body',
  partial: 'spree/listrak/order_confirmation',
  disabled: false
)

# Listrak Cart Completed, if no JS
Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'listrak_no_js_order_confirmation',
  insert_top: 'body',
  partial: 'spree/listrak/no_js_order_confirmation',
  sequence: 10,
  disabled: false
)
