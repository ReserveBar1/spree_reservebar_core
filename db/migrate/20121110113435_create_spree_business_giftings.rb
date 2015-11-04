class CreateSpreeBusinessGiftings < ActiveRecord::Migration
  def change
    create_table :spree_business_giftings do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :office_phone
      t.string :mobile_phone
      t.string :email
      t.string :delivery_date
      t.string :recipients
      t.text :message

      t.timestamps
    end
    add_index :spree_business_giftings, :user_id
  end
end
