Spree::Admin::ReportsController.class_eval do
  before_filter :verify_admin

  Spree::Admin::ReportsController::AVAILABLE_REPORTS.merge!(
    product_details: { 
      name: 'Product Details', 
      description: 'All products with details'
    },
    shipping_guinness: { 
      name: 'Guinness 1759 Shipping Summary', 
      description: 'Shipping Report for completed orders with Guinness 1759'
    },
    shipping_veu_clic_clutch: { 
      name: 'GILT - Veuve Clicquot Envelope Clutch Shipping Summary', 
      description: 'Shipping Report for completed orders with Veuve Clicquot Envelope Clutch'
    },
    shipping_veu_clic_travel_case: { 
      name: 'GILT - Veuve Clicquot Travel Case Shipping Summary', 
      description: 'Shipping Report for completed orders with Veuve Clicquot Travel Case'
    }
  )

  def product_pricing
    params.merge!(:type => "product_pricing")
    Delayed::Job.enqueue ReportCreationJob.new(current_user.id, params)
    flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  def product_details
    begin
      Delayed::Job.enqueue ProductDetailsReportJob.new(current_user.id)
      flash.notice = "Your product details report is being created. It will be emailed to you when it is ready."
    rescue
      flash[:error] = "Something went wrong with scheduling your report"
    end
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  def product_group_pricing
  end

  def shipping_guinness
    begin
      Delayed::Job.enqueue ShippingReportJob.new(current_user.id, 'GUIN1759')
      flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    rescue
      flash[:error] = "Something went wrong with scheduling your report"
    end
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  def shipping_veu_clic_clutch
    begin
      Delayed::Job.enqueue ShippingReportJob.new(current_user.id,
        'VeuClic - GILTEnvClutch')
      flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    rescue
      flash[:error] = "Something went wrong with scheduling your report"
    end
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  def shipping_veu_clic_travel_case
    begin
      Delayed::Job.enqueue ShippingReportJob.new(current_user.id,
        'VeuClic - GILTtravelCase')
      flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    rescue
      flash[:error] = "Something went wrong with scheduling your report"
    end
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  private

  def verify_admin
    unless current_user.present? && current_user.has_role?("admin")
      flash[:error] = "You do not have the proper credentials to access this report."
      redirect_back_or_default(request.env["HTTP_REFERER"])
    end
  end

end
