class ReportCreationJob < Struct.new(:current_user_id, :params)

  def perform
    params['search'] ||= {}
    params['search']['completed_at_is_not_null'] ||= '1' if Spree::Config['show_only_complete_orders_by_default']
    @show_only_completed = params['search']['completed_at_is_not_null'].present?
    params['search']['meta_sort'] ||= @show_only_completed ? 'completed_at.desc' : 'created_at.desc'
    params['search']['state_does_not_equal'] = 'canceled'

    @search = Spree::Order.metasearch(params['search'])

    if !params['search']['created_at_greater_than'].blank?
      params['search']['created_at_greater_than'] = Time.zone.parse(params['search']['created_at_greater_than']).beginning_of_day rescue ""
    end

    if !params['search']['created_at_less_than'].blank?
      params['search']['created_at_less_than'] = Time.zone.parse(params['search']['created_at_less_than']).end_of_day rescue ""
    end

    if @show_only_completed
      params['search']['completed_at_greater_than'] = params['search'].delete('created_at_greater_than')
      params['search']['completed_at_less_than'] = params['search'].delete('created_at_less_than')
    end

    @includes = ['user', 'shipments', 'payments', 'line_items']
    if @current_retailer
      @orders = @current_retailer.orders.metasearch(params['search']).includes(@includes)
    else
      @orders = Spree::Order.metasearch(params['search']).includes(@includes)
    end

    if params['type'] == 'order'
      order_ids = @orders.map(&:id)
      OrdersReportMailer.send_report(order_ids, current_user_id, params['search']).deliver
    elsif params['type'] == 'product'
      order_ids = @orders.map(&:id)
      ProductSalesReportMailer.send_report(order_ids, current_user_id, params['search']).deliver
    elsif params['type'] == 'profit_and_loss'
      order_ids = @orders.map(&:id)
      ProfitAndLossReportMailer.send_report(order_ids, current_user_id, params['search']).deliver
    elsif params['type'] == 'retailers'
      order_ids = @orders.map(&:id)
      RetailersReportMailer.send_report(order_ids, current_user_id, params['search']).deliver
    elsif params['type'] == 'product_pricing'
      ProductPricingReportMailer.send_report(current_user_id).deliver
    end
  end

end
