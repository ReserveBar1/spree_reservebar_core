Spree::UsersController.class_eval do
  
  # Change the display order of the orders o the my account page
  def show
    @orders = @user.orders.complete.order("spree_orders.created_at desc")
  end

  # Used to send an email for the Tiffany's form
  def tiffany_email
    params.delete :controller
    params.delete :action
    TiffanyMailer.send_email(params.to_s).deliver
    redirect_to '/tiffany-champagne-concierge-service-request-submitted'
  end

end
