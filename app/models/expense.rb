class Expense < ActiveRecord::Base
  belongs_to  :project
  belongs_to  :period

  validates :project_id,      presence: true
  validates :period_id ,      presence: true
  validates :commission,      numericality: true
  validates :outsourcing,     numericality: true
  validates :tickets,         numericality: true
  validates :courrier,        numericality: true
  validates :postage,         numericality: true
  validates :stationery,      numericality: true
  validates :report_binding,  numericality: true
  validates :cash_advance,    numericality: true
  validates :payment_on_be_half, numericality: true
  EXPENSE_NUMBER_FIELDS = ["commission", "outsourcing", "tickets", "courrier", "postage", "stationery", "report_binding", "cash_advance", "payment_on_be_half"]
end
