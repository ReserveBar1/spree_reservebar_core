class CreateMailLog < ActiveRecord::Migration
  def change
    create_table :spree_mail_log do |t|
      t.references :order, :null => false, :default => ''
      t.string :mail_class, :null => false, :default => ''
      t.timestamps
    end
    add_index :spree_mail_log, [:order_id, :mail_class]
  end

end
