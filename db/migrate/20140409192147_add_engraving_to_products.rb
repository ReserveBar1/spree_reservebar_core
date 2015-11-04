class AddEngravingToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :engravable, :boolean
  end
end
