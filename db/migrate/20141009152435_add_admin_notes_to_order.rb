class AddAdminNotesToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :admin_notes, :text
  end
end
