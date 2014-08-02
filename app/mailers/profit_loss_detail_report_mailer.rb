class ProfitLossDetailReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @orders = orders
    @search_params = search_params

    attachments.inline["profit_loss_detail_report.csv"] = report_csv_file
    mail(:to => @current_user.email, :content_type => "multipart/mixed", :reply_to => "noreply@reservebar.com", :subject => "Your profit/loss detail report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = ["OrderNumber", "Order Date", "Order Total", "SKU", "Website Product Price", "Retail Product Price", "Gross Bottle Profit", "Gift Suede Bag Revenue", "Gift Suede Bag Cost", "Gross Gift Suede Bag Profit", "Gift Blk Matte Revenue", "Gift Blk Matte Cost", "Gross Gift Blk Matte Box Profit", "Total Gift Packaging Profit", "SKU Shipping Surcharge By State", "Product Shipping Surcharge (Imposed Across All States)"]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        order.line_items.each do |line_item|
          website_bottle_price = line_item.price * line_item.quantity
          retailer_bottle_cost = line_item.product_cost_for_retailer
          sdbg_revenue = line_item.gift_packaging_revenue_for_sku('SDBG')
          sdbg_cost =  line_item.gift_packaging_cost_for_sku('SDBG')
          bmgc_revenue = line_item.gift_packaging_revenue_for_sku('BMGC')
          bmgc_cost = line_item.gift_packaging_cost_for_sku('BMGC')
            csv << [	order.number,
                (order.completed_at.nil? ? order.created_at : order.completed_at).to_date,
                order.total,
                line_item.variant.name,
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
                line_item.retailer_shipping_surcharge,
                line_item.global_product_shipping_surcharge,
              ]
        end
      end
    end
  end

  def report_csv_file
    if admin_user?
      admin_report
    end
  end

end
