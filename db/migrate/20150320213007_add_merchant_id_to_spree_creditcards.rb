class AddMerchantIdToSpreeCreditcards < ActiveRecord::Migration
  def change
    add_column :spree_creditcards, :bt_merchant_id, :string
  end
end
