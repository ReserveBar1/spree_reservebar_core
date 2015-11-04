class AddEngravingTextDisplayToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :display_engraving_text, :boolean, :default => true
  end
end
