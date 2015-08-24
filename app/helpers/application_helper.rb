module ApplicationHelper
  def weekend(date)
    return false if date.nil?
    return  (date.saturday? || date.sunday?)
  end
end