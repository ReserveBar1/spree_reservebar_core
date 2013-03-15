namespace :admin do
  namespace :orders do

    desc "Sending email for  orders that have not been accepted more than 6 hours"
    task :not_accepted_notification => :environment do
      Spree::OrderMailer.not_accepted_notification(6).deliver
    end
    
    desc "Regular status email to management - indicates if any orders are not progressing as needed"
    task :regular_reminder_email => :environment do
      Spree::OrderMailer.regular_reminder_email().deliver
    end
    
    desc "Get updates to shipments for all outstanding orders."
    task :get_tracking_updates => :environment do
      #Spree::ReservebarCore::ShipmentTracker.get_all_fedex_events
      #Spree::ReservebarCore::ShipmentTracker.get_all_ups_events
      Spree::ReservebarCore::ShipmentTracker.get_all_shipment_events
    end

  end
end
