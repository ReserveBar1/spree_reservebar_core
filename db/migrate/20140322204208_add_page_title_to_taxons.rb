class AddPageTitleToTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :page_title, :text
  end
end
