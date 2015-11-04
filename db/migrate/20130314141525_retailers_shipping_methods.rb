# Purpose: All limiting the available ship methods by retailer, e.g. one retailer only uses Fedex, another only UPS, a third uses local delvivery and Fedex, etc.
# The old style zone based selection does not work, since we have many retailers shippig to the same location
class RetailersShippingMethods < ActiveRecord::Migration
  def up
    create_table :spree_retailers_shipping_methods, :id => false do |t|
      t.integer :shipping_method_id, :null => false, :default => 0  
      t.integer :retailer_id, :null => false, :default => 0
    end
    
  end

  def down
    drop_table :spree_retailers_shipping_methods
  end
end
