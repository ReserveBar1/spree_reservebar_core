Spree::Admin::OrdersController.class_eval do
  before_filter :load_retailer
  after_filter :sync_unread, :only => [:show, :summary]

  # skip_before_filter :authorize_admin, :only => :gift_message

  def show
    respond_with(@order) do |format|
      if current_user.has_role?("admin")
        format.html {render}
      else
        format.html {render :action => :summary}
      end
    end
  end

  def index
    params[:search] ||= {}
    params[:search][:completed_at_is_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
    @show_only_completed = params[:search][:completed_at_is_not_null].present?
    params[:search][:meta_sort] ||= @show_only_completed ? 'completed_at.desc' : 'created_at.desc'

    @search = Spree::Order.metasearch(params[:search])

    if !params[:search][:created_at_greater_than].blank?
      params[:search][:created_at_greater_than] = Time.zone.parse(params[:search][:created_at_greater_than]).beginning_of_day rescue ""
    end

    if !params[:search][:created_at_less_than].blank?
      params[:search][:created_at_less_than] = Time.zone.parse(params[:search][:created_at_less_than]).end_of_day rescue ""
    end

    if @show_only_completed
      params[:search][:completed_at_greater_than] = params[:search].delete(:created_at_greater_than)
      params[:search][:completed_at_less_than] = params[:search].delete(:created_at_less_than)
    end

    if @current_retailer
      @orders = @current_retailer.orders.metasearch(params[:search]).includes([:user, :shipments, :payments]).page(params[:page]).per(Spree::Config[:orders_per_page])
    else
      @orders = Spree::Order.metasearch(params[:search]).includes([:user, :shipments, :payments]).page(params[:page]).per(Spree::Config[:orders_per_page])
    end
    respond_with(@orders)
  end

  def edit
    unless @order.state == 'canceled'
      @current_retailer = @order.retailer
      available_retailers = Spree::Retailer.active.where("id != ?", @current_retailer.id)
      @all_available_retailers = available_retailers.map { |r| [r.name, r.id] } # used for force updates
      unless @order.accepted_at.blank?
        available_retailers = available_retailers.where(bt_merchant_id: @current_retailer.bt_merchant_id)
      end
      @retailers = available_retailers.map { |r| [r.name, r.id] }
    end
    respond_with(@order)
  end

  def update_retailer
    old_retailer = @order.retailer
    new_retailer = Spree::Retailer.find_by_id(params[:target_retailer_id])

    if new_retailer.present?
      begin
        if old_retailer.bt_merchant_id != new_retailer.bt_merchant_id
          begin
            if @order.payments.count > 1
              flash[:error] = 'Orders with more than one payment cannot be changed between retailers with different merchant accounts automatically. Please contact technical support.'
              redirect_to edit_admin_order_path(@order) and return
            end
            # void existing payment
            payment = @order.payment
            new_payment = payment.dup
            original_cc = payment.payment_source
            original_cc.void(payment)

            new_payment.response_code = nil
            new_payment.source_id = nil

            # find credit card on new merchant account
            new_cc = Spree::Creditcard.where(gateway_customer_profile_id: original_cc.gateway_customer_profile_id, last_digits: original_cc.last_digits, cc_type: original_cc.cc_type, first_name: original_cc.first_name, last_name: original_cc.last_name, month: original_cc.month, year: original_cc.year, bt_merchant_id: new_retailer.bt_merchant_id).first
            new_payment.source_id = new_cc.id
            new_payment.save

            @order.retailer = new_retailer

            # authorize on new merchant account
            new_cc.authorize(new_payment.amount, new_payment)
            new_payment.save
          rescue
            flash[:error] = 'Retailer not updated. Something went wrong with payments.'
            redirect_to edit_admin_order_path(@order) and return
          end
        else
          @order.retailer = new_retailer
        end
        Spree::OrderMailer.retailer_removed_email(@order, old_retailer).deliver if old_retailer
        Spree::OrderMailer.retailer_submitted_email(@order).deliver if @order.retailer
      rescue
        flash[:error] = 'Something went wrong with changing the retailer. It is likely the emails just did not sent. Please confirm the changed retailer and payments.'
        redirect_to edit_admin_order_path(@order) and return
      end
      flash[:notice] = 'Retailer updated. Emails sent to the old and new retailer.'
      redirect_to admin_order_path(@order)
    else
      flash[:error] = 'Please select a retailer'
      redirect_to edit_admin_order_path(@order) and return
    end
  end

  # No additional checks or processing for moving an order between retailers or accepting
  def force_update
    begin
      # force retailer change
      if params['target_retailer_id'].present?
        new_retailer = Spree::Retailer.find(params['target_retailer_id'])
        @order.retailer = new_retailer
      end

      # force acceptance
      if params['accepted'].present? and params['accepted'] == 'yes'
        @order.update_attribute(:accepted_at, Time.now)
      end

      flash[:notice] = 'Forced updates were made to the order.'
    rescue
      flash[:error] = 'Updates could not be applied'
    end
    redirect_to admin_order_path(@order)
  end

  def export
    params.merge!(:retailer_id => @current_retailer.id) if @current_retailer
    Delayed::Job.enqueue ReportCreationJob.new(current_user.id, params)
    flash.notice = "Your report is being created. It will be emailed to you when it is ready."
    redirect_back_or_default(request.env["HTTP_REFERER"])
  end

  # Change the currently selected retailer, only avaialble to an admin user.
  def get_retailer_data
    if params[:retailer_id] && !params[:retailer_id].empty?
      session[:current_retailer_id] = params[:retailer_id]
    else
      session[:current_retailer_id] = nil
    end
    redirect_to "/admin/orders"
  end

  # Purpose: retailer accepts the order
  def accept
    load_order
    # If the order has been canceled, the retailer can no longer accept it
    if @order.state == 'canceled'
      flash["notice"] = 'This order has been canceled - do not process it!'
    elsif @order.payments.blank?
      flash[:error] = "Something went wrong with the payment on this order. Please hold off on shipping and contact ReserveBar."
      Spree::OrderMailer.no_payment_error_notification(@order).deliver
    elsif @order.accepted_at.blank? && (@current_retailer && @current_retailer.id == @order.retailer_id)
      @order.update_attribute(:accepted_at, Time.now)
      @order.create_profit_and_loss

      # If the order only has one payment on it (all order here should have only a single payment)
      # and the total order amount is lower than the payment amount, due to adjustments made after the order was submitted
      # reduce the amount in the payment to the order total
      if @order.payments.count == 1 && @order.payment.pending? && @order.total < @order.payment.amount
        @order.payment.update_attribute(:amount, @order.total)
        @order.payments.reload
      end

      begin
        @order.payments.each do |payment|
          payment.payment_source.send("capture", payment)
        end
      rescue Spree::Core::GatewayError => error
        # Try to authorize and capture a new payment on the same source
        begin
          unless @order.payments.count > 1
            payment = @order.payment
            credit_card = payment.payment_source
            # check retailer matches merchant account of payment_source, in case order was moved
            if credit_card.bt_merchant_id == @order.retailer.bt_merchant_id
              new_payment = payment.dup
              new_payment.response_code = nil
              new_payment.save
              # authorize and capture new payment
              credit_card.authorize(new_payment.amount, new_payment)
              credit_card.send("capture", new_payment)
            else
              raise 'Order changed Retailers'
            end
          else
            raise 'More than one payment'
          end
        rescue
          @order.update_attribute(:accepted_at, nil)
          # Handle messaging to retailer - error flash that something
          flash[:error] = "Something went wrong with the payment on this order. Please hold off on shipping and contact ReserveBar."
          # Dump error to separate log
          log_payment_error(error)
          # Send email to reservbar that something went wrong
          Spree::OrderMailer.capture_payment_error_notification(@order, error).deliver
        end
      end
    end
    redirect_to admin_order_url(@order)
  end

  # Purpose: retailer has packed the order and it is ready for pick up by Fedex / Courier
  def order_complete
    load_order
    if @order.state == 'canceled'
      flash["notice"] = 'This order has been canceled - do not process it!'
    elsif @order.packed_at.blank? && (@current_retailer && @current_retailer.id == @order.retailer_id)
      @order.update_attribute(:packed_at, Time.now)
    end
    redirect_to admin_order_url(@order)
  end

  # used for testing only to preview the email
  def giftor_shipped_email
    load_order
    respond_with(@order) do |format|
      format.html { render :template => "spree/order_mailer/giftor_shipped_email.html.erb", :layout => false }
    end
  end

  # used for testing only to preview the email
  def retailer_submitted_email
    load_order
    respond_with(@order) do |format|
      format.html { render :template => "spree/order_mailer/retailer_submitted_email.html.erb", :layout => false }
    end
  end

  # used for testing only to preview the email
  def retailer_canceled_email
    load_order
    respond_with(@order) do |format|
      format.html { render :template => "spree/order_mailer/cancel_email_retailer.html.erb", :layout => false }
    end
  end

  # used for testing only to preview the email
  def regular_reminder_email
    @retailers = Spree::Retailer.active

    respond_to do |format|
      format.html { render :template => "spree/order_mailer/regular_reminder_email.html.erb", :layout => false }
    end
  end

  # Retailer view of order
  def summary
  end

  private

  def load_retailer
    if current_user.has_role?("admin")
      if session[:current_retailer_id]
        @current_retailer = Spree::Retailer.find(session[:current_retailer_id])
      end
    elsif current_user.has_role?("retailer")
      @current_retailer = current_user.retailer
    end
  end

  def sync_unread
    @order.update_attributes(:unread => false, :viewed_at => Time.now) if @order.unread && (@order.retailer && @order.retailer == @current_retailer)
  end

  def log_payment_error(exception)
    new_logger = Logger.new('log/payment_errors.log')
    new_logger.info("\n\n===== Exception Caught at #{Time.now} for Order Number #{@order.number} =====")
    new_logger.info(exception.message)
    new_logger.info("\n\n===== End Exception  =====\n\n")
  end
end
