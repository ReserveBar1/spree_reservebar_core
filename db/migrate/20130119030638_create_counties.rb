class CreateCounties < ActiveRecord::Migration
  def change
    create_table :spree_counties do |t|
      t.string :name, :null => false, :default => ''
      t.references :state, :null => false, :default => 0
      t.string :state_abbr, :null => false, :default => ''
      t.text :geometry, :null => false, :default => ''
      t.string :geo_id, :null => false, :default => ''
      t.string :geo_id2, :null => false, :default => ''
      t.integer :county_num, :null => false, :default => 0
      t.references :country, :null => false, :default => 0
      t.timestamps
    end
    add_index :spree_counties, [:name, :state_id]
  end

end
