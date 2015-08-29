class AddEngravingLineLimitToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :engraving_line_limit, :integer, :default => 3
  end
end
