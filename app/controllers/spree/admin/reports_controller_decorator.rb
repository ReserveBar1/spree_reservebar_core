Spree::Admin::ReportsController.class_eval do

  Spree::Admin::ReportsController::AVAILABLE_REPORTS.merge!(
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
    Delayed::Job.enqueue ReportCreationJob.new(current_user, params)
    flash.notice = "Your report is being created. It will be emailed to you when it is ready."
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

end
