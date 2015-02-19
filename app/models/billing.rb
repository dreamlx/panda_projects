class Billing < ActiveRecord::Base
  validates   :number,        uniqueness: true
  validates   :number,        presence: true
  validates   :project_id,    presence: true
  validates   :period_id,     presence: true
  # validates   :person_id,     presence: true
  validates   :user,          presence: true
  validates   :billing_date,  presence: true
  validates   :status,        presence: true

  belongs_to  :project
  belongs_to  :period
  belongs_to  :person
  belongs_to  :user
  has_many    :receive_amounts
end
