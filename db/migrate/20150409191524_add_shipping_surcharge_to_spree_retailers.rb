class AddShippingSurchargeToSpreeRetailers < ActiveRecord::Migration
  def change
    add_column :spree_retailers, :shipping_surcharge, :float, default: 3.0
  end
end
