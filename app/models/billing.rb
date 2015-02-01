class Billing < ActiveRecord::Base
  validates   :number,      uniqueness: true

  belongs_to  :project
  belongs_to  :period
  belongs_to  :person
  has_many    :receive_amounts
end
