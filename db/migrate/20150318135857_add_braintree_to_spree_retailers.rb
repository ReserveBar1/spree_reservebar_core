class AddBraintreeToSpreeRetailers < ActiveRecord::Migration
  def change
    add_column :spree_retailers, :bt_merchant_id, :string
    add_column :spree_retailers, :bt_public_key, :string
    add_column :spree_retailers, :bt_private_key, :string
  end
end
