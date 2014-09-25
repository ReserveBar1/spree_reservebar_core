class ProductSalesReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(orders, user, search_params)
    @current_user = user
    @orders = orders
    @search_params = search_params

    attachments.inline["product_sales_report.csv"] = { :mime_type => 'text/csv', :content => report_csv_file }
    mail(:to => @current_user.email, :content_type => "multipart/mixed", :reply_to => "noreply@reservebar.com", :subject => "Your product sales report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = ["OrderNumber", "Order details link", "Customer email address", "Ship-to State", "Product name", "Number of bottles", "Multiple products in the order", "OrderDate", "AcceptedDate", "OrderState", "PaymentState", "ShipmentState", "Product price", "GiftPackagingCost(not paid to retailer)", "RB margin (Product price - product cost)", "Promo", "Total promo discount($)", "Retailer", "ProductCostForRetailer"]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        line_items = order.line_items
        line_items.each do |line_item|
          csv << [order.number,
            spree.order_url(order, :protocol => 'https'),
            order.email,
            order.ship_address.state.abbr,
            line_item.product.nil? ? nil : strip_tags(line_item.product.name).gsub(/&quot;|,/, ''),
            line_item.quantity,
            (line_items.size > 1 ? "Yes" : "No"),
            (@show_only_completed ? order.completed_at : order.created_at).to_date,
            order.accepted_at.nil? ? nil : order.accepted_at.to_date,
            order.state,
            order.payment_state,
            order.shipment_state,
            line_item.price,
            line_item.adjustments.eligible.gift_packaging.map(&:amount).sum,
            line_item.margin_for_site,
            order.adjustments.eligible.promotion.first.try(:label),
            order.adjustments.eligible.promotion.first.try(:amount),
            order.retailer.try(:name),
            line_item.product_cost_for_retailer
          ]
        end
      end
    end
  end

  def non_admin_report
    column_names = ["OrderNumber", "ProductName", "NumberOfBottles", "MultipleProductsPerOrder", "OrderState", "PaymentState", "ShipmentState", "ProductCostForRetailer"]

    CSV.generate do |csv|
      csv << column_names

      @orders.each do |order|
        line_items = order.line_items
        line_items.each do |line_item|
          csv << [order.number,
            line_item.product.nil? ? nil : strip_tags(line_item.product.name).gsub(/&quot;|,/, ''),
            line_item.quantity,
            (line_items.size > 1 ? "Yes" : "No"),
            order.state,
            order.payment_state,
            order.shipment_state,
            line_item.product_cost_for_retailer
          ]
        end
      end
    end
  end

  def report_csv_file
    if admin_user?
      admin_report
    else
      non_admin_report
    end
  end

end
