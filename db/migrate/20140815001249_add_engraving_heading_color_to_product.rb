class AddEngravingHeadingColorToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :engraving_heading_color, :string
  end
end
