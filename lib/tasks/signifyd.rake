namespace :signifyd do
  desc 'Update Signifyd case information on all relevant orders'
  task update: :environment do
    # Update all open cases
    signifyd_cases = SignifydCase.open.all
    signifyd_cases.each do |signifyd_case|
      Delayed::Job.enqueue SignifydJob.new(signifyd_case.order_id)
    end
  end
end
