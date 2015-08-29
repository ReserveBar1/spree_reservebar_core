class TaxonAddMetaData < ActiveRecord::Migration
  def up
    add_column :spree_taxons, :meta_keywords, :string, :null => false, :default => ""
    add_column :spree_taxons, :meta_title, :string, :null => false, :default => ""
    add_column :spree_taxons, :meta_description, :string, :null => false, :default => ""
    
  end

  def down
    remove_column :spree_taxons, :meta_keywords
    remove_column :spree_taxons, :meta_title
    remove_column :spree_taxons, :meta_description
  end
end
