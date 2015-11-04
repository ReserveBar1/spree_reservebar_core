class ShipmentDetailAddShipevents < ActiveRecord::Migration
  def up
    add_column :spree_shipment_details, :ship_events, :text, :null => :true
  end

  def down
    remove_column :spree_shipment_details, :ship_events
  end
end
