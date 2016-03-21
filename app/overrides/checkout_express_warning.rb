Deface::Override.new(
  virtual_path: "spree/checkout/edit",
  name: "express_warning",
  insert_after: "code[erb-loud]:contains('checkout_form_')",
  partial: 'spree/checkout/express_warning',
  disabled: false
)
