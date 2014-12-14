class ShippingReportMailer < ActionMailer::Base
  default :from => "noreply@reservebar.com"

  def send_report(current_user_id, sku)
    @user = Spree::User.find_by_id(current_user_id)
    variant = Spree::Variant.where(deleted_at: nil).find_by_sku(sku)
    order_ids = Spree::LineItem.where(variant_id: variant.id).map(&:order_id)
    @unshipped_orders = Spree::Order.where(id: order_ids, state: 'complete',
      shipment_state: 'pending').includes(:ship_address)

    attachments["#{sku}_shipping_report.csv"] = { mime_type: 'text/csv',
      content: report_csv_file }
    mail(to: @user.email, reply_to: "noreply@reservebar.com",
      subject: "Your shipping report for #{sku} is ready.")
  end

  private

  def report_csv_file

    column_names = [
      "Completed At",
      "Order Number",
      "Purchaser Email",
      "Recipient Name",
      "Recipient Address1",
      "Recipient Address2",
      "Recipient City",
      "Recipient State",
      "Recipient Zipcode",
      "Recipient Phone"
    ]

    CSV.generate do |csv|
      csv << column_names
      @unshipped_orders.each do |order|
        csv << [
          order.completed_at.strftime('%e %b %Y'),
          order.number,
          order.email,
          "#{order.ship_address.firstname} #{order.ship_address.lastname}",
          order.ship_address.address1,
          order.ship_address.address2,
          order.ship_address.city,
          order.ship_address.state.abbr,
          order.ship_address.zipcode,
          order.ship_address.phone
        ]
      end
    end

  end
end
