namespace :period do
  task :create => :environment do
    if Date.today.day == 8
      Period.create(
        number: Date.today.beginning_of_month.to_s,
        starting_date: Date.today.beginning_of_month,
        ending_date: Date.today.beginning_of_month + 14.days
        )
    elsif Date.today.day == 23
      Period.create(
        number: (Date.today.beginning_of_month + 15.days).to_s,
        starting_date: Date.today.beginning_of_month + 15.days,
        ending_date: Date.today.end_of_month
        )
    end
  end
end