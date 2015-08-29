class AddStateBlacklistAndPageTitleToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :state_blacklist, :string
    add_column :spree_products, :page_title, :text
  end
end
