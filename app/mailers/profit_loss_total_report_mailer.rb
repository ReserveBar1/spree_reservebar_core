class ProfitLossTotalReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @orders = orders
    @search_params = search_params

    attachments.inline["profit_loss_total_report.csv"] = report_csv_file
    mail(:to => @current_user.email, :content_type => "multipart/mixed", :reply_to => "noreply@reservebar.com", :subject => "Your profit/loss total report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
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
      admin_report
    end
  end

end
