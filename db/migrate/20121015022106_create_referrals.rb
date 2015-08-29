class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :spree_referrals do |t|
      t.string	:referrible_type
      t.integer :referrible_id
      t.string	:http_referrer
      t.string	:domain

      t.timestamps
    end
    
    add_index :spree_referrals, [:referrible_id, :referrible_type], :name => 'index_spree_referrible_id_and_type'
  end
end
