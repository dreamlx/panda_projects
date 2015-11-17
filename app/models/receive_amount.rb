class ReceiveAmount < ActiveRecord::Base
  belongs_to  :billing
  validates :billing_id,      presence: true
  validates :receive_amount,  numericality: true
end
