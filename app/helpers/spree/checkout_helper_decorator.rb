Spree::CheckoutHelper.class_eval do
  def checkout_states
    %w(address delivery payment complete)
  end
end
