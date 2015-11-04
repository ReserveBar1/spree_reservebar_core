class AddColumnViewedAtToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :viewed_at, :datetime
  end
end
