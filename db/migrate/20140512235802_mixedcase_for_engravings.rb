class MixedcaseForEngravings < ActiveRecord::Migration
  def change
    add_column :spree_products, :engraving_top_offset, :integer
    add_column :spree_products, :engraving_left_offset, :integer
    add_column :spree_products, :engraving_uppercase, :boolean
  end
end
