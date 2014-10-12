class ProfitAndLoss < ActiveRecord::Base

  belongs_to :order, :class_name => "Spree::Order"
  after_initialize :init

  def init
    self.total_bottle_price = set_total_bottle_price
    self.gift_packaging_charge = set_gift_packaging_charge
    self.shipping_charge = set_shipping_charge
    # self.shipping_margin = set_shipping_margin
    self.state_fulfillment_fee = set_state_fulfillment_fee
    self.sales_tax = set_sales_tax
    self.gross_proceeds_before_promotion = set_gross_proceeds_before_promotion

    self.retailer_bottle_price = set_retailer_bottle_price
    self.corrugated_box_fee = set_corrugated_box_fee
    self.credit_card_fees = set_credit_card_fees
    self.net_retailer_disbursements = set_net_retailer_disbursements

    self.gift_packaging_cost = set_gift_packaging_cost
    self.corrugated_cost = set_corrugated_cost
    self.total_packaging_costs = set_total_packaging_costs

    self.shipping_costs = set_shipping_charge

    self.total_disbursements = set_total_disbursements

    self.net_revenues_before_promotion = set_net_revenues_before_promotion
    self.promotions = set_promotions
    self.net_revenues_after_promotion = set_net_revenues_after_promotion
  end

  private

  def set_total_bottle_price
    order.line_items.map{ |line_item| line_item.price * line_item.quantity}.sum
  end

  def set_gift_packaging_charge
    order.gift_packaging_total
  end

  def set_shipping_charge
    order.ship_total
  end

  # def set_shipping_margin
  #   shipping_charge_uplift + order.shipping_surcharge
  # end

  def set_state_fulfillment_fee
    order.state_fulfillment_fee
  end

  def set_sales_tax
    order.tax_total
  end

  def set_gross_proceeds_before_promotion
    sum = total_bottle_price +
            gift_packaging_charge +
            shipping_charge +
            state_fulfillment_fee +
            sales_tax
    sum.to_f
  end

  def set_retailer_bottle_price
    order.line_items.collect { |line_item| line_item.product_cost_for_retailer }.sum
  end

  def set_corrugated_box_fee
    corrugated_box_fee_value
  end

  def set_credit_card_fees
    self.credit_card_percentage = set_credit_card_percentage
    credit_card_percentage * (retailer_bottle_price + sales_tax)
  end

  def set_net_retailer_disbursements
    sum = retailer_bottle_price +
            sales_tax +
            corrugated_box_fee +
            credit_card_fees
    sum.to_f
  end

  def set_gift_packaging_cost
    (gift_packaging_charge * 10) / 3
  end

  def set_corrugated_cost
    corrugated_cost_value
  end

  def set_total_packaging_costs
    gift_packaging_charge + corrugated_cost
  end

  def set_total_disbursements
    net_retailer_disbursements + total_packaging_costs + shipping_charge
  end

  def set_net_revenues_before_promotion
    gross_proceeds_before_promotion - total_disbursements
  end

  def set_promotions
    order.adjustments.eligible.promotion.first.try(:amount) || 0.0
  end

  def set_net_revenues_after_promotion
    net_revenues_before_promotion - promotions
  end

  def set_credit_card_percentage
    credit_card_cost = Spree::CompanyCost.find_by_name("Credit Card Fees")

    if credit_card_cost.present?
      credit_card_cost.percentage / 100
    else
      0.0
    end
  end

  def corrugated_cost_value
    corrugated_cost = Spree::CompanyCost.find_by_name("Corrugated Cost")

    if corrugated_cost.present?
      corrugated_cost.value
    else
      0.0
    end
  end

  def corrugated_box_fee_value
    corrugated_box_fee = Spree::CompanyCost.find_by_name("Corrugated Box Fee")

    if corrugated_box_fee.present?
      corrugated_box_fee.value
    else
      0.0
    end
  end

  def shipping_charge_uplift
    order.shipping_method.calculator.preferred_uplift rescue 0.0
  end


end
