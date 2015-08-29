class AddressAddHomeBusinessSelector < ActiveRecord::Migration
  def up
    add_column :spree_addresses, :is_business, :boolean, :null => false, :default => false
  end

  def down
    remove_column :spree_addresses, :is_business
  end
end
