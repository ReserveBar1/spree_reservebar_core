class CreateCompanyCosts < ActiveRecord::Migration
  def change
    create_table :spree_company_costs do |t|
      t.string  :name
      t.decimal :value,      :precision => 8, :scale => 2
      t.decimal :percentage, :precision => 5, :scale => 2

      t.timestamps
    end
  end
end
