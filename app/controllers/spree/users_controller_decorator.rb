Spree::UsersController.class_eval do
  
  # Change the display order of the orders o the my account page
  def show
    @orders = @user.orders.complete.order("spree_orders.created_at desc")
  end

  # Used to send an email for the concierge forms
  def concierge_email
    brand_name = params['brand_name']
    params.delete :controller
    params.delete :action
    params.delete :brand_name
    ConciergeMailer.send_email(params.to_s, brand_name.capitalize).deliver
    redirect_to "/#{brand_name}-concierge-service-request-submitted"
  end

end
