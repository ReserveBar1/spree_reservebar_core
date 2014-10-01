Spree::Admin::ProductGroupsController.class_eval do

  def pricing_export
    Delayed::Job.enqueue PricingExportJob.new(current_user, params)
    flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    redirect_to edit_admin_product_group_url(params[:product_group_id])
  end

end
