Spree::LineItem.class_eval do

  def update_costs
    return if variant.blank?

    product_costs = variant.product_costs.where(:retailer_id => order.retailer_id)
    cost = product_costs.empty? ? 0 : product_costs.first.cost_price * quantity
    update_attribute_without_callbacks(:product_cost_for_retailer, cost)
  end

  # Handle case where the product cost for the retailer has not been defined yet
  def product_cost_for_retailer
    product_costs = variant.product_costs.where(:retailer_id => order.retailer_id)
    cost = product_costs.empty? ? 0 : product_costs.first.cost_price * quantity
    update_attribute_without_callbacks(:product_cost_for_retailer, cost)
    return cost
  end

  # Calulate the profit for a given line item based on the retailer's product costs
  # For routing purposes, we assume that the profit is zero if the product cost is not filled in.
  def profit(retailer)
    product_costs = variant.product_costs.where(:retailer_id => retailer.id)
    product_costs.empty? ? 0 : (price - product_costs.first.cost_price) * quantity

  end

  # Calculate any shipping surcharges for a line item,based on the global shipping surcharges for the product
  # and the retailer specific surcharges. Retailer specific takes precedence over global
  def shipping_surcharge
    # can only calculate retailer specific surcharge if we know the retailer
    if self.order.retailer_id
      surcharge = retailer_shipping_surcharge
    end
    # old global surcharge:
    if surcharge == 0.0
      surcharge = global_product_shipping_surcharge
    end

    if surcharge == nil
      surcharge = 0.0
    end
    surcharge
  end

  def global_product_shipping_surcharge
    (variant.product.shipping_surcharge * quantity) if variant.product.present?
  end

  def retailer_shipping_surcharge
    begin
      return variant.product_costs.where(:retailer_id => self.order.retailer_id).first.shipping_surcharge * quantity
    rescue
      return 0.0
    end
  end

  # calculate the fulfillment fee for this line item through the product_costs.fulfillment fee times qty
  # If there is a fee defined for this retailer and sku, it is used.
  # Otherwise the retailer's global fulfillment fee is used.
  def fulfillment_fee
    begin
      if variant.product_costs.where(:retailer_id => self.order.retailer_id).first.fulfillment_fee > 0
        variant.product_costs.where(:retailer_id => self.order.retailer_id).first.fulfillment_fee * quantity
      else
        self.order.retailer.fulfillment_fee * quantity
      end
    rescue
      begin
        self.order.retailer.fulfillment_fee * quantity
      rescue
        0.0
      end
    end
  end


  # Returns the total revenue of gift packaging for a given SKU
  def gift_packaging_revenue_for_sku(sku)
    amount = 0.0
    begin
      amount = adjustments.eligible.gift_packaging.first.amount if adjustments.eligible.gift_packaging.first.originator.sku == sku
    rescue
      amount = 0.0
    end
    amount
  end

  # Returns the total cost of gift packaging for a given SKU
  def gift_packaging_cost_for_sku(sku)
    amount = 0.0
    cost_per_item = Spree::Variant.find_by_sku(sku).cost_price
    begin
      amount = (quantity * cost_per_item) if adjustments.eligible.gift_packaging.first.originator.sku == sku
    rescue
      amount = 0.0
    end
    amount
  end


  # Allows use to add arbitrary customization data to any line item
  # To be used with the Johnnie Walker Blue Label, might later replace with spree_flexi_variants
  # Example data: {:type => 'jwb_engraving, :data => {:line1 => 'bla', :line2 => 'said', :line3 => 'toad'}}
  # Can we derive partial names from the type? - I hope so.
  preference :customization, :string, :default => nil

end
