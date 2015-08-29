class CreditcardAddUserIdRetailerId < ActiveRecord::Migration
  def up
    add_column :spree_creditcards, :user_id, :integer, :null => false, :default => 0
    add_column :spree_creditcards, :retailer_id, :integer, :null => false, :default => 0
    Spree::Creditcard.all.each do |creditcard|
      if creditcard.gateway_customer_profile_id == nil
        retailer_id = 0
      else
        retailer_id = creditcard.payments.first.order.retailer_id rescue 0
      end
      user_id = creditcard.payments.first.order.user_id rescue 0
      creditcard.update_attributes_without_callbacks(:retailer_id => retailer_id, :user_id => user_id)
    end
  end

  def down
    remove_column :spree_creditcards, :user_id
    remove_column :spree_creditcards, :retailer_id
  end
end
