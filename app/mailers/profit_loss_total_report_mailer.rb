class ProfitLossTotalReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @profit_and_losses = orders.each_with_object([]) do |order, ary|
      if order.profit_and_loss.present?
        ary << order.profit_and_loss
      else
        ary << order.build_profit_and_loss
      end
    end
    @search_params = search_params

    attachments.inline["profit_loss_total_report.csv"] = report_csv_file
    mail(:to => @current_user.email, :content_type => "multipart/mixed", :reply_to => "noreply@reservebar.com", :subject => "Your profit/loss total report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  #TODO: update this name or create new report mailer
  def new_admin_report
    CSV.generate do |csv|
      csv << [ "Total Bottle Price", @profit_and_losses.collect(&:total_bottle_price).sum ]
      csv << [ "Gift Packaging", @profit_and_losses.collect(&:gift_packaging_charge).sum ]
      csv << [ "Shipping", @profit_and_losses.collect(&:shipping_charge).sum ]
      csv << [ "Shipping Margin", @profit_and_losses.collect(&:shipping_margin).sum ]
      csv << [ "State Fulfillment Fee", @profit_and_losses.collect(&:state_fulfillment_fee).sum ]
      csv << [ "Sales Tax", @profit_and_losses.collect(&:sales_tax).sum ]
      csv << [ "Gross Proceeds Before Promotion", @profit_and_losses.collect(&:gross_proceeds_before_promotion).sum ]
      csv << []
      csv << [ "Retailer Bottle Price", @profit_and_losses.collect(&:retailer_bottle_price).sum ]
      csv << [ "Sales Tax", @profit_and_losses.collect(&:sales_tax).sum ]
      csv << [ "Corrugated Box Fee", @profit_and_losses.collect(&:corrugated_box_fee).sum ]
      csv << [ "Credit Card Fees", @profit_and_losses.collect(&:credit_card_fees).sum ]
      csv << [ "Net Retailer Disbursements", @profit_and_losses.collect(&:net_retailer_disbursements).sum ]
      csv << []
      csv << [ "Gift Packaging Cost", @profit_and_losses.collect(&:gift_packaging_cost).sum ]
      csv << [ "Corrugated Cost", @profit_and_losses.collect(&:corrugated_cost).sum ]
      csv << [ "Total Packaging Costs", @profit_and_losses.collect(&:total_packaging_costs).sum ]
      csv << []
      csv << [ "Shipping Costs", @profit_and_losses.collect(&:shipping_costs).sum ]
      csv << []
      csv << [ "Total Disbursements", @profit_and_losses.collect(&:total_disbursements).sum ]
      csv << []
      csv << [ "Net Revenues Before Promotion", @profit_and_losses.collect(&:net_revenues_before_promotion).sum ]
      csv << [ "Promotions", @profit_and_losses.collect(&:promotions).sum ]
      csv << [ "Net Revenues After Promotion", @profit_and_losses.collect(&:net_revenues_after_promotion).sum ]
    end
  end

  def admin_report
    column_names = ["OrderNumber", "Order Date", "Order Total", "Total Website Bottle(s) Price", "Total Retail Bottle(s) Price", "Total Bottle(s) Gross Profit", "Gift Suede Bag Revenue", "Gift Suede Bag Cost", "Gross Gift Suede Bag Profit", "Gift Blk Matte Revenue", "Gift Blk Matte Cost", "Gross Gift Blk Matte Box Profit", "Total Gift Packaging Profit", "Total Shipping Charged to Customer", "Shipping Cost Pulled From FedEx API", "Gross Shipping Profit", "Nationwide Shipping Surcharge", "SKU Nationwide Shipping Surcharge", "SKU Retailer-Specific Shipping Surcharge", "Total Shipping Surcharges", "State Fulfillment Fee", "TOTAL GROSS PROFIT PER ORDER"]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        website_bottle_price = order.line_items.map{|line_item| line_item.price * line_item.quantity}.sum
        retailer_bottle_cost = order.line_items.collect {|line_item| line_item.product_cost_for_retailer }.sum
        sdbg_revenue = order.gift_packaging_revenue_for_sku('SDBG')
        sdbg_cost =  order.gift_packaging_cost_for_sku('SDBG')
        bmgc_revenue = order.gift_packaging_revenue_for_sku('BMGC')
        bmgc_cost = order.gift_packaging_cost_for_sku('BMGC')
        shipping_charge_uplift = order.shipping_method.calculator.preferred_uplift rescue 0.0
        total_profit = website_bottle_price - retailer_bottle_cost +
          sdbg_revenue - sdbg_cost + bmgc_revenue - bmgc_cost +
          order.ship_total - order.ship_fedex +
          shipping_charge_uplift + order.shipping_surcharge

          csv << [	order.number,
              (order.completed_at.nil? ? order.created_at : order.completed_at).to_date,
              order.total,
              website_bottle_price,
              retailer_bottle_cost,
              website_bottle_price - retailer_bottle_cost,
              sdbg_revenue,
              sdbg_cost,
              sdbg_revenue - sdbg_cost,
              bmgc_revenue,
              bmgc_cost,
              bmgc_revenue - bmgc_cost,
              sdbg_revenue - sdbg_cost + bmgc_revenue - bmgc_cost,
              order.ship_total,
              order.ship_fedex,
              order.ship_total - order.ship_fedex,
              shipping_charge_uplift,
              order.global_product_shipping_surcharge,
              order.retailer_shipping_surcharge,
              shipping_charge_uplift + order.shipping_surcharge,
              order.state_fulfillment_fee,
              total_profit
            ]
      end
    end
  end

  def report_csv_file
    if admin_user?
      new_admin_report
    end
  end

end
