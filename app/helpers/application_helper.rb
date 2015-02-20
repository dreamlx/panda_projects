module ApplicationHelper
  def weekend(date)
    return  (date.saturday? || date.sunday?)
  end
end