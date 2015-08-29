class AddPartnerIdToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :partner_id, :integer, :null => true
  end
end
