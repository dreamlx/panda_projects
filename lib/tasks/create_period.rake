namespace :period do
  task :create => :environment do
    if Date.today.day == 2
      period = Period.create(
        number: Date.today.beginning_of_month.to_s,
        starting_date: Date.today.beginning_of_month,
        ending_date: Date.today.beginning_of_month + 14.days
        )
      Project.live.each do |project|
        if project.service_code && project.service_code.code && (project.service_code.code.to_i >= 60 && project.service_code.code.to_i <= 68)
          Expense.find_or_create_by(project_id: project.id, period_id: period.id, report_binding: 100, memo: ("job_code in 60-68 add 100RMB|" + period.number))
        end
      end
    elsif Date.today.day == 16
      Period.create(
        number: (Date.today.beginning_of_month + 15.days).to_s,
        starting_date: Date.today.beginning_of_month + 15.days,
        ending_date: Date.today.end_of_month
        )
    end
  end
end