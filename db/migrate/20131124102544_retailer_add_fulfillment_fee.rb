class RetailerAddFulfillmentFee < ActiveRecord::Migration
  def up
    add_column :spree_retailers, :fulfillment_fee, :decimal, :precision => 8, :scale => 6, :default => 0.0
    Spree::Retailer.update_all(:fulfillment_fee => 0.0)
  end

  def down
    remove_column :spree_retailers, :fulfillment_fee
  end
end
