# Packed_at column is used so the retailer can indicate that he has packed the order and it is ready to be picked up by Fedex
class OrderAddPackedAt < ActiveRecord::Migration
  def up
    add_column :spree_orders, :packed_at, :datetime, :null => true
  end

  def down
    remove_column :spree_orders, :packed_at
  end
end
