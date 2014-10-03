Spree::Admin::ReportsController.class_eval do

  def product_pricing
    params.merge!(:type => "product_pricing")
    Delayed::Job.enqueue ReportCreationJob.new(current_user, params)
    flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  def product_group_pricing
  end

end
