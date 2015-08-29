class AddProductCostForRetailerToLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :product_cost_for_retailer, :decimal, :null => true, :default => nil, :precision => 8, :scale => 2
  end
end
