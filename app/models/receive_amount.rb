class ReceiveAmount < ActiveRecord::Base
  belongs_to  :billing
  validates :billing_id,      presence: true
  validates :receive_amount,  numericality: true
  validates :invoice_no,      presence: true
  validates :receive_date,    presence: true
end
