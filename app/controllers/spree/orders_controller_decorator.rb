Spree::OrdersController.class_eval do
  skip_before_filter :verify_authenticity_token, only: :signifyd_webhook

  require 'exceptions'

  before_filter :check_bottle_number_limit, :only => [:populate, :update]
  before_filter :check_ardbeg_bottle_number_limit, :only => [:populate, :update]

  rescue_from Exceptions::BottleLimitPerOrderExceededError, :with => :bottle_limit_exceeded
  rescue_from Exceptions::ArdbegBottleLimitPerOrderExceededError, with: :ardbeg_bottle_limit_exceeded

  # Add customization to line item after the other stuff 
  after_filter :handle_customization, :only => [:populate, :update]

  # Shows the current incomplete order from the session (Cart)
  def edit
    @order = current_order(true)
    @order.update_attribute(:browser_ip, request.remote_ip) if @order.present?
  end

  def signifyd_webhook
    signifyd_case = Spree::Order.find_by_number(params['orderId']).signifyd_case
    if signifyd_case.nil?
      render nothing: true, status: 404
    else
      begin
        signifyd_case.score = params['adjustedScore']
        signifyd_case.status = params['status']
        signifyd_case.review_disposition = params['reviewDisposition']
        signifyd_case.guarantee_disposition = params['guaranteeDisposition']
        signifyd_case.save
        render nothing: true, status: 200
      rescue
        render nothing: true, status: 500
      end
    end
  end

  protected

  # We'll need to add customization data to the SKU's either when it was submitted in the form or when the SKU requires it but it has not been 
  # submitted. The latter happens when SKUis added to the cart from a taxon page, where the form data is not available.
  def handle_customization
    @order = current_order(false)
    # Process if we got customization data from the product or cart page
    if params[:customization] # && params[:elected_engraving] == 'true'
      # Find line item that can be customized, and set its preferred_customization_data
      begin
        params[:customization][:data].each do |id, text|
          line_item = (id == 'new') ? @order.line_items.last : @order.line_items.where(id: id).first
          line_item.preferred_customization = text.to_json if line_item.product.engravable?
        end
      rescue Exception => e
        # Don't do anything for now
        Rails.logger.warn "Failed updating line item with customization data. Order #{@order.number}"
      end
    else # Check if a customizable SKU has been added without the customizatiob data in the form
      # Find line item that can be customized, and set its preferred_customization_data
      begin
        line_item = @order.line_items.last
        line_item.preferred_customization = {'line1' => '', 'line2' => '', 'line3' => ''}.to_json if line_item.product.engravable?
      rescue Exception => e
        # Don't do anything for now
        Rails.logger.warn "Failed updating line item with customization data. Order #{@order.number}"
      end        
    end
  end

  def bottle_limit_exceeded
    respond_to do |format|
      format.html {
        flash[:notice] = "<p>Thank you for trying to add products to your shopping cart. We appreciate your business; however,  we currently cannot accept an order that contains more than 12 bottles. </p><p>If you wish to purchase more than 12 bottles (e.g., more than one case of wine), please create separate orders, each of which must contain 12 or fewer bottles. We apologize for the inconvenience.</p>".html_safe
        redirect_to cart_path
      }
      format.js {
        render :populate_bottle_limit_exceeded
      }
    end
  end

  def ardbeg_bottle_limit_exceeded
    respond_to do |format|
      format.html {
        flash[:notice] = "<p>Thank you for trying to add products to your shopping cart. We appreciate your business; however,  we currently cannot accept an order that contains more than 1 bottle of Ardbeg Supernova 2015.</p>".html_safe
        redirect_to cart_path
      }
      format.js {
        render :populate_ardbeg_bottle_limit_exceeded
      }
    end
  end

  # Do not allow the user to add more than 12 bottles to the order.
  # If he tries, show him a message instead of allowing it
  def check_bottle_number_limit
    @order = current_order(true)
    
    # calculate number of bottles user is trying to add:
    bottles_to_add = 0
    # populate method has either products or variants:
    params[:products].each do |product_id,variant_id|
      bottles_to_add += params[:quantity].to_i if !params[:quantity].is_a?(Hash)
      bottles_to_add += params[:quantity][variant_id.to_i].to_i if params[:quantity].is_a?(Hash)
    end if params[:products]

    params[:variants].each do |variant_id, quantity|
      bottles_to_add += quantity.to_i
    end if params[:variants]

    # update method has "order"=>{"line_items_attributes"=>{"0"=>{"quantity"=>"1", "id"=>"111"}, "1"=>{"quantity"=>"10", "id"=>"113"}}}
    bottles_total = 0
    if params[:order] && params[:order][:line_items_attributes]
      params[:order][:line_items_attributes].each do |index, attributes|
        bottles_total += attributes['quantity'].to_i
      end
    end
    if (@order.number_of_bottles + bottles_to_add > 12) || (bottles_total > 12)
      raise Exceptions::BottleLimitPerOrderExceededError
    end
  end

  def check_ardbeg_bottle_number_limit
    @order = current_order(true)
    max_bottles = 1

    # bottle limit check for Ardbeg Supernova 2015
    if @order.line_items.map(&:product).map(&:permalink).include?('ardbeg-supernova-2015')
      @order.line_items.each do |li|
        if li.product.permalink == 'ardbeg-supernova-2015'
          desired_bottles = li.quantity

          if params[:variants].present?
            # updating from product#index (search) or custom page
            params[:variants].each do |variant, quantity|
              desired_bottles += quantity.to_i if variant.to_i == li.variant_id
            end
          elsif params[:order] && params[:order][:line_items_attributes]
            # updating from cart
            params[:order][:line_items_attributes].each do |index, attributes|
              desired_bottles += attributes['quantity'].to_i if attributes['id'].to_i == li.id
            end
          end

          if desired_bottles > max_bottles
            li.update_attributes(quantity: max_bottles)
            raise Exceptions::ArdbegBottleLimitPerOrderExceededError
          end
        end
      end
    end
  end

end
