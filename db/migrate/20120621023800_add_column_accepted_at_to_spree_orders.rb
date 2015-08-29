class AddColumnAcceptedAtToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :accepted_at, :datetime
  end
end
