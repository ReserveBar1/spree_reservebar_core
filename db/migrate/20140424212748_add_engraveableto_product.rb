class AddEngraveabletoProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :engraving_image_url, :string
    add_column :spree_products, :engraving_color, :string
    add_column :spree_products, :engraving_char_limit, :integer
  end
end
