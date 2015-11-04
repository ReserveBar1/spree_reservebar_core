class ChangeColumnsForSpreeBusinessGiftings < ActiveRecord::Migration
  def up
  	remove_column :spree_business_giftings, :office_phone
  	remove_column :spree_business_giftings, :mobile_phone
  	add_column :spree_business_giftings, :phone_number, :string
  end

  def down
  	remove_column :spree_business_giftings, :phone_number
  	add_column :spree_business_giftings, :office_phone, :string
  	add_column :spree_business_giftings, :mobile_phone, :string
  end
end
