class SignifydJob < Struct.new(:order_id)
  require 'httparty'

  class SignifydAPI
    include HTTParty
    debug_output $stdout

    def set_api_metadata(order_id)
      @base_uri = 'https://api.signifyd.com/v2/cases'
      @api_key = 'IcrmDy9H74DmsKsISOj05RDdl'
      @headers = { 'content_type' => 'application/json' }
      @order = Spree::Order.find(order_id)
    end

    def send_order(order_id)
      set_api_metadata(order_id)
      bill_addr = @order.bill_address
      ship_addr = @order.ship_address
      body = {
        "purchase" => {
          "browserIpAddress" => @order.user.current_sign_in_ip,
          "orderId" => @order.number,
          "createdAt" => @order.created_at.utc.iso8601,
          "totalPrice" => @order.total.to_f
        },
        "recipient" => {
          "fullName" => "#{ship_addr.firstname} #{ship_addr.lastname}",
          "confirmationEmail" => @order.email,
          "deliveryAddress" => {
            "streetAddress" => ship_addr.address1,
            "unit" => ship_addr.address2,
            "city" => ship_addr.city,
            "provinceCode" => ship_addr.state.abbr,
            "postalCode" => ship_addr.zipcode,
            "countryCode" => ship_addr.country.iso,
          }
        },
        "card" => {
          "cardHolderName" => "#{bill_addr.firstname} #{bill_addr.lastname}",
          "billingAddress" => {
            "streetAddress" => bill_addr.address1,
            "unit" => bill_addr.address2,
            "city" => bill_addr.city,
            "provinceCode" => bill_addr.state.abbr,
            "postalCode" => bill_addr.zipcode,
            "countryCode" => bill_addr.country.iso,
          }
        }
      }

      begin
        resp = self.class.post(
          @base_uri, body: body.to_json,
          headers: @headers, basic_auth: { username: @api_key, password: '' }
        )
        if resp.success?
          @order.build_signifyd_case(case_number: resp['investigationId']).save
        end
      rescue
        raise 'Comm error with Signifyd'
      end
    end
  end

  def perform
    order = Spree::Order.find(order_id)
    unless order.signifyd_case.present?
      SignifydAPI.new.send_order(order_id) if order.complete?
      sleep 15
    end
  end

end
