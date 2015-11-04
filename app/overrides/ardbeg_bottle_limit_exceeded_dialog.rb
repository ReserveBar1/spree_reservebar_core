Deface::Override.new(
  virtual_path: "spree/products/index",
  name: "product_index_ardbeg_bottle_limit_exceeded_dialog",
  insert_after: "[data-hook='search_results']",
  partial: "spree/shared/ardbeg_bottle_limit_exceeded_dialog",
  disabled: false
)
