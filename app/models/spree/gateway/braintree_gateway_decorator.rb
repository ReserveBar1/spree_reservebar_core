Spree::Gateway::BraintreeGateway.class_eval do

  # Normally the gateway reads the preferences from the preference database
  # We want to force the gateway to use the login and password from the retailer associated with the payment
  # See CreditCard class decorator for changes
  # after gateway = payment.payment_method call gateway.set_provider(payment.order.retailer.gateway_login, payment.order.retailer.gateway_password)
  
  def set_provider(merchant_id, public_key, private_key)
    gateway_options = options

    gateway_options.delete :merchant_id if gateway_options.has_key?(:merchant_id)
    gateway_options.delete :public_key if gateway_options.has_key?(:public_key)
    gateway_options.delete :private_key if gateway_options.has_key?(:private_key)

    gateway_options[:merchant_id] = merchant_id
    gateway_options[:public_key] = public_key
    gateway_options[:private_key] = private_key

    ActiveMerchant::Billing::Base.gateway_mode = gateway_options[:server].to_sym
    @provider ||= provider_class.new(gateway_options)
  end
end
