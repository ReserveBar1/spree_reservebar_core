class ProductAddSeoText < ActiveRecord::Migration
  def up
    add_column :spree_products, :seo_text, :text
  end

  def down
    remove_column :spree_products, :seo_text
  end
end
