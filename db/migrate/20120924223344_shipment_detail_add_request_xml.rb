class ShipmentDetailAddRequestXml < ActiveRecord::Migration
  def up
    add_column :spree_shipment_details, :request_xml, :text, :null => true
  end

  def down
    remove_column :spree_shipment_details, :request_xml
  end
end
