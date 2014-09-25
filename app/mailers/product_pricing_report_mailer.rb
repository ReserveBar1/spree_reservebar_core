class ProductPricingReportMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "noreply@reservebar.com"

  def send_report(product_costs, user)
    @current_user = user
    @product_costs = product_costs

    attachments["product_pricing_report.csv"] = { :mime_type => 'text/csv', :content => report_csv_file }
    mail(:to => @current_user.email, :content_type => "multipart/mixed", :reply_to => "noreply@reservebar.com", :subject => "Your product pricing report is ready.")
  end

  private

  def admin_user?
    @current_user.has_role?("admin")
  end

  def admin_report
    column_names = ["Product Name",
                    "SKU",
                    "Retailer",
                    "Cost",
                    "Shipping Surcharge",
                    "Fulfillment Fee"]

    CSV.generate do |csv|
      csv << column_names

      @product_costs.each do |product_cost|
        csv << [product_cost.variant.name,
                product_cost.variant.sku,
                product_cost.retailer.present? ? product_cost.retailer.name : "",
                product_cost.cost_price,
                product_cost.shipping_surcharge,
                product_cost.fulfillment_fee
               ]
      end
    end

  end

  def non_admin_report
  end

  def report_csv_file
    if admin_user?
      admin_report
    else
      non_admin_report
    end
  end

end
