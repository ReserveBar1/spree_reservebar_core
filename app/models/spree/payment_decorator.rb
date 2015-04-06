Spree::Payment.class_eval do
  
  def payment_method
    gateway = Spree::PaymentMethod.find(self.payment_method_id)
    if self.order && self.order.retailer
      retailer = self.order.retailer
      if gateway.type == 'Spree::Gateway::BraintreeGateway'
        gateway.set_provider(
          retailer.bt_merchant_id, 
          retailer.bt_public_key,
          retailer.bt_private_key
        )
      else
        gateway.set_provider(retailer.gateway_login, retailer.gateway_password)
      end
    end
    gateway
  end

end
