class ProductAddTileTitle < ActiveRecord::Migration
  def up
    add_column :spree_products, :tile_title, :string, :null => false, :default => ""
    Spree::Product.all.each do |product|
      product.update_attribute_without_callbacks(:tile_title, product.name)
    end
  end

  def down
    remove_column :spree_products, :tile_title
  end
end
