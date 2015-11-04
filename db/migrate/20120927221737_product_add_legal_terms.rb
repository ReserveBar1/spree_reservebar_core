class ProductAddLegalTerms < ActiveRecord::Migration
  def up
    add_column :spree_products, :legal_terms, :string, :null => false, :default => ""
  end

  def down
    remove_column :spree_products, :legal_terms
  end
end
