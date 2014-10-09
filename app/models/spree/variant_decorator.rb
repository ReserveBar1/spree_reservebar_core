# html_invoice changes options_text to something useless, so we override it back to the original here
Spree::Variant.class_eval do

  has_many :product_costs

  # remove colon for JW Black action, reinstate afterwards
  def options_text
    #self.option_values.sort { |ov1, ov2| ov1.option_type.position <=> ov2.option_type.position }.map { |ov| "#{ov.option_type.presentation}: #{ov.presentation}" }.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
    self.option_values.sort { |ov1, ov2| ov1.option_type.position <=> ov2.option_type.position }.map { |ov| "#{ov.option_type.presentation} #{ov.presentation}" }.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
  end


  # TODO: This is a stub, make it show the actual bottle size or 'n.a.'
  def bottle_size
    "750ml"
  end

  def product_cost_for_retailer(retailer)
    matching_product_cost = product_costs.select { |pc| pc.retailer == retailer }.first

    if matching_product_cost.present? && matching_product_cost.cost_price > 0.00
      matching_product_cost.cost_price
    else
      "N.A."
    end
  end

  def product_cost_for_retailers
    product_costs = []

    retailers ||= Spree::Retailer.all

    retailers.each do |retailer|
      product_costs << product_cost_for_retailer(retailer)
    end

    product_costs
  end

end
