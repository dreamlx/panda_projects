module ApplicationHelper
  def weekend(date)
    return false if date.nil?
    return  (date.saturday? || date.sunday?)
  end

  def remove_zero(table_date)
    return (table_date == 0 ? "" : table_date)
  end

  def keep_dash(table_data)
    return (table_data ==0 ? "-" : table_data)
  end

  def add_expense(job_code, price, msg)
    project = Project.find_by(job_code: job_code)
    if project.status.title == "Active"
      Expense.create(
        project_id: project.id,
        period_id: Period.today_period.id,
        report_binding: price,
        memo: msg)
    end
  end
end