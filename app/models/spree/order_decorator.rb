Spree::Order.class_eval do
  attr_accessible :is_legal_age, :is_gift, :gift_attributes, :unread, :viewed_at, :admin_notes
  attr_accessor :is_gift

  attr_accessible :has_accepted_terms, :newsletter_optin
  attr_accessor :has_accepted_terms

  has_and_belongs_to_many :retailers, :join_table => :spree_orders_retailers
  belongs_to :gift

  has_one :profit_and_loss, dependent: :destroy
  has_one :signifyd_case, dependent: :destroy

  accepts_nested_attributes_for :gift

  scope :accepted, where('accepted_at IS NOT NULL')
  scope :not_older_than_thirty_days,
    lambda {
      where("created_at > ?", Time.now - 30.days)
    }

  scope :non_accepted_hours,
    lambda {|n|
      where(["spree_orders.accepted_at is ? and spree_orders.updated_at < ? and spree_orders.state = ?", nil, Time.now - n.hours, "complete"])
    }

  search_methods :non_accepted_hours

  # Scope to find all orders that have not been accepted by retailers in a given time frame
  scope :not_accepted_hours,
    lambda {|number_of_hours|
      where(["spree_orders.accepted_at is ? and spree_orders.updated_at < ? and spree_orders.state = ?", nil, Time.now - number_of_hours.hours, "complete"])
    }

  search_methods :not_accepted_hours

  scope :opted_in, where('newsletter_optin IS NOT NULL')

  # KN: the lines below (before the state_machine is defined) are pulled from the current version of spree
  # and allow us to redefine the state machine inside this order decorator.
  # https://github.com/spree/spree/blob/master/core%2Fapp%2Fmodels%2Fspree%2Forder%2Fcheckout.rb#L36-L40

  # To avoid a ton of warnings when the state machine is re-defined
  StateMachine::Machine.ignore_method_conflicts = true
  # To avoid multiple occurrences of the same transition being defined
  # On first definition, state_machines will not be defined
  state_machines.clear if respond_to?(:state_machines)

  # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
  state_machine :initial => 'cart', :use_transactions => false do

    event :next do
      transition :from => 'cart',     :to => 'address'
      transition :from => 'address',  :to => 'delivery'
      transition :from => 'delivery', :to => 'payment', :if => :payment_required?
      transition :from => 'delivery', :to => 'complete'
      transition :from => 'payment', :to => 'complete'
    end

    event :cancel do
      transition :to => 'canceled', :if => :allow_cancel?
    end
    event :return do
      transition :to => 'returned', :from => 'awaiting_return'
    end
    event :resume do
      transition :to => 'resumed', :from => 'canceled', :if => :allow_resume?
    end
    event :authorize_return do
      transition :to => 'awaiting_return'
    end

    before_transition :to => 'complete' do |order|
      begin
        order.process_payments!
      rescue Spree::Core::GatewayError
        if Spree::Config[:allow_checkout_on_gateway_error]
          true
        else
          false
        end
      end
    end

    before_transition :to => ['delivery'] do |order|
      order.shipments.each { |s| s.destroy unless s.shipping_method.available_to_order?(order) }
      order.set_retailer
    end

    after_transition :to => 'complete', :do => :finalize!
    after_transition :to => 'delivery', :do => :create_tax_charge!
    after_transition :to => 'payment',  :do => :create_shipment!
    after_transition :to => 'resumed',  :do => :after_resume
    after_transition :to => 'canceled', :do => :after_cancel

    # KN: the transition callbacks below were part of our original modifications to the state_machine
    # they need to be below the code above because, for whatever reason, the order of these things
    # matters in order for the state machien to work properly
    before_transition :to => 'delivery', :do => :validate_legal_drinking_age?

    # add the gift notification after order.finalize!
    # note that this adds a new callback to the chain, it does not override the existing callbacks
    # we had called order.finalize! here, which was then executed twice....
    after_transition :to => 'complete' do |order, transition|
      order.gift_notification if order.is_gift?
      Spree::OrderMailer.delay.retailer_submitted_email(order) if (order.retailer && !Spree::MailLog.has_email_been_sent_already?(order, 'Order::retailer_submitted_email') )
      Delayed::Job.enqueue SignifydJob.new(order.id) if Rails.env == 'production'
    end
  end

  # 20150409: Jason Knebel
  # We are no longer calculating shipping surcharges based on line items.
  # They are now being set for each retailer.
  
  def shipping_surcharge
    # Calculate the shipping_surcharges for the order, based on line items
    # line_items.inject(0.0) {|charge, line_item| charge = charge + (line_item.quantity * line_item.shipping_surcharge)}
    retailer.shipping_surcharge
  end

  # def global_product_shipping_surcharge
   #  line_items.inject(0.0) {|charge, line_item| charge = charge + (line_item.quantity * line_item.global_product_shipping_surcharge)}
  # end

  # def retailer_shipping_surcharge
   #  line_items.inject(0.0) {|charge, line_item| charge = charge + (line_item.quantity * line_item.retailer_shipping_surcharge)}
  # end

  # calculate the fulfillment_fee based on the line items
  def fulfillment_fee
    line_items.inject(0.0) {|charge, line_item| charge = charge + (line_item.fulfillment_fee)}
  end

  def create_fulfillment_fee!
    self.adjustments.where(label: "Additional State Fulfillment Fee").destroy_all
    adjustments.create(:amount => self.fulfillment_fee,
                             :source => self,
                             :originator => Spree::FulfillmentFee.first,
                             :locked => false,
                             :label => "Additional State Fulfillment Fee")
  end

  # returns the shipping charges as pulled from Fedex, before any uplifts have been applied.
  # TODO: Implement
  def ship_fedex
    0.0
  end

  # Returns the state fulfillment fee
  def state_fulfillment_fee
    adjustments.eligible.where(:label => 'Additional State Fulfillment Fee').first.amount rescue 0.0
  end

  # Pseudo states that embedd special logic for reservebar.com
  # uses packed_at column to allow the retailer to indicate that he pas packed the item and it is ready for pick up
  # we'll do state transition such that retailer hits 'ready for pick up' , which changes packed_at, and then fede scanning changes to shipped
  def extended_state
    if self.state == 'complete'
      if !self.accepted_at
        'submitted'
      elsif self.accepted_at && (self.packed_at == nil) && self.shipment_state != 'shipped'
        'accepted'
      elsif self.packed_at && (self.shipment_state != 'shipped' && self.shipment_state != 'delivered')
        'ready_for_pick_up'
      elsif self.shipment_state == 'shipped'
        'shipped'
      elsif self.shipment_state == 'delivered'
        'delivered'
      end
    else
      self.state
    end
  end


  # Override the address used for calculating taxes.
  # Reservebar.com uses the retailer's physial address, rather then the ship_address to determine taxes
  # Returns the relevant zone (if any) to be used for taxation purposes.  Uses default tax zone
  # unless there is a specific match
  def tax_zone
    if Spree::Config[:tax_using_retailer_address]
      if retailer
        zone_address = retailer.physical_address
      else
        zone_address = nil
      end
    else
      zone_address = Spree::Config[:tax_using_ship_address] ? ship_address : bill_address
    end
    Spree::Zone.match(zone_address) || Spree::Zone.default_tax
  end


  def gift_notification
    Spree::OrderMailer.delay.giftee_notify_email(self) unless (self.gift.email.blank? || Spree::MailLog.has_email_been_sent_already?(self, 'Order::giftee_notify_email'))
  end

  def retailer
    self.retailers.last
  end

  def retailer=(retailer)
    self.retailers = []
    self.retailers << retailer
    update_line_item_costs
  end

  def retailer_id
    retailer.id if retailer
  end

  def validate_legal_drinking_age?
    is_legal_age
  end


  def is_gift
    is_gift? ? true : false
  end

  def is_gift?
    gift.present?
  end

  # get all shipping categories for an order, used to find a retailer that can fulfil this order.
  def shipping_categories
    self.line_items.collect {|l| l.product.shipping_category_id}.uniq
  end

  # returns true, if the order only has products in the wine category
  def has_only_wine?
    self.shipping_categories.count == 1 &&
    self.shipping_categories.first == Spree::ShippingCategory.find_by_name('Wine')
  end

  # returns true if this order contains alcoholic items, used by fedex requests to add alcohol and so forth
  def contains_alcohol?
    (self.shipping_categories - [1,2,3,4]).empty? && !self.shipping_categories.empty?
  end


  # Calculates the total amount due to the retailer based on current settings
  # Note that the gift packaging cost does not go to the retailer, but all sales tax does
  def total_amount_due_to_retailer
    shipping = self.retailer.reimburse_shipping_cost ? self.ship_total : 0.0
    product_cost = (self.line_items.collect {|line_item| line_item.product_cost_for_retailer }).sum
    self.tax_total + shipping + product_cost
  end

  # Calculate the profit if we route this order to a given retailer, based on the product costs table.
  def profit(retailer)
    begin
      (self.line_items.collect {|line_item| line_item.profit(retailer) }).sum
    rescue
      0
    end
  end


  # Returns the number of bottles in the order, so we can limit
  # Cache counts?
  def number_of_bottles
    bottles = self.line_items.inject(0) {|bottles, line_item| bottles + line_item.quantity}
  end

  # true if the order contains products that are routed towards / away from any retailer
  def contains_routed_products?
    line_items.inject(false) {|routed, line_item| routed = routed || line_item.product.is_routed?}
  end

  def update_line_item_costs
    line_items.each { |line_item| line_item.update_costs }
  end

  # Set retailer based on shipping address and the order contents
  # The retailer selector will return false if we cannot ship to the state.
  # Need to handle that some way or other.
  def set_retailer
    if Spree::Config[:use_county_based_routing]
      order_retailer = Spree::ReservebarCore::RetailerSelectorProfit.select(self)
    else
      order_retailer = Spree::ReservebarCore::RetailerSelector.select(self)
    end
    # And save the association between order and order_retailer
    if order_retailer.id != retailer_id
      self.retailer = order_retailer
      # Create the fulfillment fee adjustment for the order, now that we know the order_retailer:
      create_fulfillment_fee!
      # Somehow this got lost along the way, force it here, where the order_retailer (and therefore the tax rate) is known
      # If the order_retailer is changed, we need to recreate the tax charge
      create_tax_charge!
      ## Reload the current order, the tax charge does not show up on the first page load
      #reload
    end
  end


  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed
  def finalize!
    update_attribute(:completed_at, Time.now)
    Spree::InventoryUnit.assign_opening_inventory(self)
    # lock any optional adjustments (coupon promotions, etc.)
    adjustments.optional.each { |adjustment| adjustment.update_attribute('locked', true) }
    Spree::OrderMailer.delay.confirm_email(self)

    self.state_events.create({
      :previous_state => 'cart',
      :next_state     => 'complete',
      :name           => 'order' ,
      :user_id        => (Spree::User.respond_to?(:current) && Spree::User.current.try(:id)) || self.user_id                       })
  end

  private

  # Override original method so that the new shipment.state == delivered is accounted for
  # Updates the +shipment_state+ attribute according to the following logic:
  #
  # shipped   when all Shipments are in the "shipped" state
  # partial   when at least one Shipment has a state of "shipped" and there is another Shipment with a state other than "shipped"
  #           or there are InventoryUnits associated with the order that have a state of "sold" but are not associated with a Shipment.
  # ready     when all Shipments are in the "ready" state
  # backorder when there is backordered inventory associated with an order
  # pending   when all Shipments are in the "pending" state
  #
  # The +shipment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
  def update_shipment_state
    self.shipment_state =
    case shipments.count
    when 0
      nil
    when shipments.delivered.count
      'delivered'
    when shipments.shipped.count
      'shipped'
    when shipments.ready.count
      'ready'
    when shipments.pending.count
      'pending'
    else
      'partial'
    end
    self.shipment_state = 'backorder' if backordered?

    if old_shipment_state = self.changed_attributes['shipment_state']
      self.state_events.create({
        :previous_state => old_shipment_state,
        :next_state     => self.shipment_state,
        :name           => 'shipment',
        :user_id        => (Spree::User.respond_to?(:current) && Spree::User.current && Spree::User.current.id) || self.user_id
      })
    end
  end

  # Pulled in from 1.3.2 version to update the payment_state of the order on cancel
  def after_cancel
    restock_items!

    #TODO: make_shipments_pending
    Spree::OrderMailer.cancel_email(self).deliver
    Spree::OrderMailer.cancel_email_retailer(self).deliver
    unless %w(partial shipped delivered).include?(shipment_state)
      self.payment_state = 'credit_owed'
    end
  end

end
