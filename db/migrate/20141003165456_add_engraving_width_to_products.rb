class AddEngravingWidthToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :engraving_width, :integer, :default => 100
  end
end
