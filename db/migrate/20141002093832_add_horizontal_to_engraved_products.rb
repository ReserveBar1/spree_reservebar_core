class AddHorizontalToEngravedProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :has_horizontal_engraving, :boolean, :default => false
  end
end
