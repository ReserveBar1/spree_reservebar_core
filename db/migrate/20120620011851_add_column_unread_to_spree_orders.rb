class AddColumnUnreadToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :unread, :boolean, :default => true
  end
end
