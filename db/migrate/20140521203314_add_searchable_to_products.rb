class AddSearchableToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :searchable, :boolean, default: true
  end
end
