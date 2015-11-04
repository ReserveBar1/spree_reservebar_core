class CreateFulfillmentFees < ActiveRecord::Migration
  def up
    create_table :spree_fulfillment_fees do |t|
      t.timestamps
    end
    Spree::FulfillmentFee.create
  end
  
  def down
    drop_table :spree_fulfillment_fees
  end
end
