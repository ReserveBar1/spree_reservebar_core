class AddEngravingFontStyleToProducts < ActiveRecord::Migration
  def change
    unless column_exists?(:spree_products, :engraving_font_style)
      add_column :spree_products, :engraving_font_style, :string, :default => "EB Garamond"
    end
  end
end
