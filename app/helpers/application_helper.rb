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
end