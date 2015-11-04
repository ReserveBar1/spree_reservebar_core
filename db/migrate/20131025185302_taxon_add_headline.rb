class TaxonAddHeadline < ActiveRecord::Migration
  def up
    add_column :spree_taxons, :headline, :string, :null => false, :default => ''
  end

  def down
    remove_column :spree_taxons, :headline
  end
end
