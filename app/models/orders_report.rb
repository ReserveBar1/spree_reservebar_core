class OrdersReport
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def summary
    {
      "Gross Proceeds Before Promotion" => gross_proceeds_before_promotion,
      "Net Retailer Disbursements" => net_retailer_disbursements,
      "Total Packaging Costs" => total_packaging_cost,
      "Total Disbursements" => total_disbursements,
      "Net Revenues Before Promotion" => net_revenues_before_promotion,
      "Net Revenues After Promotion" => net_revenues_after_promotion
    }
  end

  def total_bottle_price
    order.line_items.map{ |line_item| line_item.price * line_item.quantity}.sum
  end

  def gift_packaging_charge
    order.gift_packaging_total
  end
  alias :gift_packaging_cost :gift_packaging_charge

  def shipping_charge
    order.ship_total
  end
  alias :shipping_cost :shipping_charge
  alias :shipping :shipping_charge

  def shipping_margin
    shipping_charge_uplift + order.shipping_surcharge
  end

  def state_fulfillment_fee
    order.state_fulfillment_fee
  end

  def sales_tax
    order.tax_total
  end

  def gross_proceeds_before_promotion
    sum = total_bottle_price +
            gift_packaging_charge +
            shipping_charge +
            shipping_margin +
            state_fulfillment_fee +
            sales_tax
    sum.to_f
  end
  alias :gross_proceeds_before_promotions :gross_proceeds_before_promotion

  def retailer_bottle_price
    order.line_items.collect { |line_item| line_item.product_cost_for_retailer }.sum
  end

  def net_retailer_disbursements
    (retailer_bottle_price + sales_tax).to_f
  end
  alias :net_retailer_disbursement :net_retailer_disbursements

  # TODO: update this method to derive corrugated cost based on how this is currently done manually
  def corrugated_cost
    0
  end
  alias :corrugated_costs :corrugated_cost

  def total_packaging_costs
    gift_packaging_charge + corrugated_cost
  end
  alias :total_packaging_cost :total_packaging_costs

  def total_disbursements
    net_retailer_disbursements + total_packaging_cost + shipping_charge
  end
  alias :total_disbursement :total_disbursements

  def net_revenues_before_promotion
    gross_proceeds_before_promotion - total_disbursements
  end
  alias :net_revenue_before_promotion :net_revenues_before_promotion

  def promotions
    order.adjustments.eligible.promotion.first.try(:amount) || 0.0
  end
  alias :promotion :promotions

  def net_revenues_after_promotion
    net_revenues_before_promotion - promotions
  end
  alias :net_revenue_after_promotion :net_revenues_after_promotion

  private

  def shipping_charge_uplift
    order.shipping_method.calculator.preferred_uplift rescue 0.0
  end

end
