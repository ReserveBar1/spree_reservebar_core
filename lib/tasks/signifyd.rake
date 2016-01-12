namespace :signifyd do
  desc 'Update Signifyd case information on all relevant orders'
  task update: :environment do
    # Create cases for recent orders that don't have one
    orders = Spree::Order.complete.where("created_at > ?", '20151210'.to_datetime).includes(:signifyd_case)
    orders.each do |order|
      if order.complete?
        unless order.signifyd_case.present?
          Delayed::Job.enqueue SignifydJob.new(order.id)
        end
      end
    end
  end
end
