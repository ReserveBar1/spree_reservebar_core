class AddActualShippingChargeToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :actual_shipping_charge, :decimal, :precision => 8, :scale => 2
  end
end
