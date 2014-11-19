module Spree
  # This class stores the product cost for each retailer
  # Reservebar uses this to determine the payout for each product for a given retailer
  # Total payout may include the shipping fees, depending on retailer
  class ProductCost < ActiveRecord::Base
    belongs_to :retailer
    belongs_to :variant


    def shipping_surcharge_is_not_zero
      where('shipping_surcharge_is_not_zero > 0')
    end

    def self.import(file)
      log = ''
      i = 1
      CSV.foreach(file, headers: true) do |row|
        h = row.to_hash
        i += 1

        unless h.values.uniq == [nil]
          begin
            retailer = Spree::Retailer.find_by_name(h["retailer_name"])
            variant  = Spree::Variant.find_by_sku(h["sku"])
            product_cost = Spree::ProductCost.find_by_retailer_id_and_variant_id(retailer.id, variant.id) if retailer.present? && variant.present?

            if product_cost.present?
              product_cost.cost_price         = h["cost"].to_f               if h["cost"].present?
              product_cost.shipping_surcharge = h["shipping_surcharge"].to_f if h["shipping_surcharge"].present?
              product_cost.fulfillment_fee    = h["fulfillment_fee"].to_f    if h["fulfillment_fee"].present?
              product_cost.save
            else
              log += "Row #{i}: Cannot find retailer -- #{h['retailer_name']}<br />" unless retailer.present?
              log += "Row #{i}: Cannot find product sku -- #{h['sku']}<br />" unless variant.present?
              log += "Row #{i}: Cannot find product cost for #{retailer.name} and #{variant.sku}<br />" if retailer.present? && variant.present?
            end
          rescue => e
            Rails.log e
          end
        end
      end
      return log
    end

  end
end
