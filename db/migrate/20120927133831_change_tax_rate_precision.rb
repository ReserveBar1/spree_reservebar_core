class ChangeTaxRatePrecision < ActiveRecord::Migration
  def up
    change_column :spree_tax_rates, :amount, :decimal, :precision => 8, :scale => 5
  end

  def down
    change_column :spree_tax_rates, :amount, :decimal, :precision => 8, :scale => 4
  end
end
