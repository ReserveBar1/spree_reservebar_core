class CreateProfitAndLosses < ActiveRecord::Migration
  def change
    create_table :profit_and_losses do |t|
      t.references :order

      t.decimal :total_bottle_price,              :precision => 8, :scale => 2
      t.decimal :gift_packaging_charge,           :precision => 8, :scale => 2
      t.decimal :shipping_charge,                 :precision => 8, :scale => 2
      t.decimal :shipping_margin,                 :precision => 8, :scale => 2
      t.decimal :state_fulfillment_fee,           :precision => 8, :scale => 2
      t.decimal :sales_tax,                       :precision => 8, :scale => 2
      t.decimal :gross_proceeds_before_promotion, :precision => 8, :scale => 2

      t.decimal :retailer_bottle_price,      :precision => 8, :scale => 2
      t.decimal :corrugated_box_fee,         :precision => 8, :scale => 2
      t.decimal :credit_card_fees,           :precision => 8, :scale => 2
      t.decimal :net_retailer_disbursements, :precision => 8, :scale => 2

      t.decimal :gift_packaging_cost,   :precision => 8, :scale => 2
      t.decimal :corrugated_cost,       :precision => 8, :scale => 2
      t.decimal :total_packaging_costs, :precision => 8, :scale => 2

      t.decimal :shipping_costs, :precision => 8, :scale => 2

      t.decimal :total_disbursements, :precision => 8, :scale => 2

      t.decimal :net_revenues_before_promotion, :precision => 8, :scale => 2
      t.decimal :promotions,                    :precision => 8, :scale => 2
      t.decimal :net_revenues_after_promotion,  :precision => 8, :scale => 2

      t.decimal :credit_card_percentage,           :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
