# Insert on Address page, if there are Glenlivet products
Deface::Override.new(
  virtual_path: 'spree/checkout/edit',
  name: 'glenlivet_guardians_opt_in',
  insert_after: "code[erb-loud]:contains('checkout_form_')",
  partial: 'spree/checkout/glenlivet_guardians_opt_in',
  disabled: true
)
