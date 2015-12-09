namespace :signifyd do
  desc 'Update Signifyd case information on all relevant orders'
  task update: :environment do
    # Create cases for recent orders that don't have one
    orders = Spree::Order.complete.where("created_at > ?", '20151210'.to_datetime).includes(:signifyd_case)
    orders.each do |order|
      unless order.signifyd_case.present?
        Delayed::Job.enqueue SignifydJob.new(order.id)
      end
    end

    # Update all open cases
    signifyd_cases = SignifydCase.open.all
    signifyd_cases.each do |signifyd_case|
      Delayed::Job.enqueue SignifydJob.new(signifyd_case.order_id)
    end
  end
end
