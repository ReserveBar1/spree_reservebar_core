class SignifydJob < Struct.new(:order_id)
  require 'httparty'

  def perform
    order = Spree::Order.find(order_id)
   if order.complete?
      unless order.signifyd_case.present?
        SignifydAPI.new(order_id).send_order
        sleep 15
      end
      SignifydAPI.new(order_id).get_order
    end
  end

  class SignifydAPI
    include HTTParty

    def initialize(order_id)
      @base_uri = 'https://api.signifyd.com/v2/cases'
      @api_key = 'IcrmDy9H74DmsKsISOj05RDdl'
      @headers = { 'content_type' => 'application/json' }
      @order = Spree::Order.find(order_id)
    end

    def send_order
      user = @order.user
      ship_method = @order.shipments.first.shipping_method
      bill_addr = @order.bill_address
      ship_addr = @order.ship_address
      body = {
        "purchase" => {
          "browserIpAddress" => user.current_sign_in_ip,
          "orderId" => @order.number,
          "createdAt" => @order.created_at.utc.iso8601,
          "paymentGateway" => "BRAINTREE",
          # "avsResponseCode" => "",
          # "cvvResponseCode" => "",
          "orderChannel" => "WEB",
          "totalPrice" => @order.total.to_f,
          "shipments" => [{
            "shipper" => "FedEx",
            "shippingMethod" => ship_method.name,
            "shippingPrice" => ship_method.price,
          }],
        },
        "recipient" => {
          "fullName" => "#{ship_addr.firstname} #{ship_addr.lastname}",
          "confirmationEmail" => @order.email,
          "confirmationPhone" => bill_addr.phone,
          "deliveryAddress" => {
            "streetAddress" => ship_addr.address1,
            "city" => ship_addr.city,
            "provinceCode" => ship_addr.state.abbr,
            "postalCode" => ship_addr.zipcode,
            "countryCode" => ship_addr.country.iso,
          }
        },
        "card" => {
          "cardHolderName" => "#{bill_addr.firstname} #{bill_addr.lastname}",
          # "bin" => "",
          "billingAddress" => {
            "streetAddress" => bill_addr.address1,
            "city" => bill_addr.city,
            "provinceCode" => bill_addr.state.abbr,
            "postalCode" => bill_addr.zipcode,
            "countryCode" => bill_addr.country.iso,
          }
        },
        "userAccount" => {
          "email" => user.email,
          "username" => "#{user.login unless user.login.include?('@example.net')}",
          "created_at" => user.created_at.utc.iso8601,
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

    def get_order
      signifyd_case = @order.signifyd_case

      begin
        resp = self.class.get(
          "#{@base_uri}/#{signifyd_case.case_number}",
          headers: @headers, basic_auth: { username: @api_key, password: '' }
        )
        if resp.success?
          signifyd_case.status = resp['status']
          signifyd_case.score = resp['score']
          signifyd_case.review_disposition = resp['reviewDisposition']
          signifyd_case.save
        end
      rescue
        raise 'Comm error with Signifyd'
      end
    end
  end

end
