namespace :update do
  task :billing_number => :environment do
    unless Dict.find_by(category: "billing_number", title: Date.today.strftime("%Y%m%d"))
      Dict.find_by(category: "billing_number").update(title: Date.today.strftime("%Y%m%d"), code: "0000")
    end
  end
end