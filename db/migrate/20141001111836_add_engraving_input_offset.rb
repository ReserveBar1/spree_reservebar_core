class AddEngravingInputOffset < ActiveRecord::Migration
  def change
    add_column :spree_products, :engraving_input_top_offset, :integer, :default => 30
    add_column :spree_products, :engraving_input_left_offset, :integer, :default => 317
  end
end
