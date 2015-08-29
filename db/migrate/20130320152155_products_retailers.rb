# Create an association between products and retailers to allow routing preferences to be set
class ProductsRetailers < ActiveRecord::Migration
  def change
    create_table :spree_products_retailers do |t|
      t.integer :product_id, :null => false, :default => 0  
      t.integer :retailer_id, :null => false, :default => 0
      t.string :route, :null => false, :default => 0
      t.boolean :is_active, :null => false, :default => true
    end

  end

end
