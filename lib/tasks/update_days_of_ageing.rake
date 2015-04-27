namespace :update do
  task :days_of_ageing => :environment do
    Billing.received.update_all(days_of_ageing: 0)
    Billing.outstanding.each do |billing|
      billing.update_column(:days_of_ageing, (Date.today - (billing.billing_date || billing.created_on.to_date) ))
    end
  end
end