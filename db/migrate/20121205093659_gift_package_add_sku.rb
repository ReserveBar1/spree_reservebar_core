class GiftPackageAddSku < ActiveRecord::Migration
  def up
    add_column :spree_gift_packages, :sku, :string, :null => false, :default => ""
  end

  def down
    remove_column :spree_gift_packages, :sku
  end
end
