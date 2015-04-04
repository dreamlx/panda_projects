class Period < ActiveRecord::Base
  validates :number,        uniqueness: true
  validates :number,        presence:   true
  validates :starting_date, presence: true
  validates :ending_date,   presence: true
  has_many  :deductions
  has_many  :expenses
  has_many  :personalcharges
  has_many  :outsourcings
  has_many  :commissions
  has_many  :billings
  has_many  :ufafees
  has_many  :limit_fees
  
  def self.today_period
    today = Date.today.to_s
    return where("starting_date <= ? AND ending_date >= ?", today, today).first || order(number: :desc).first
  end

  def self.period_number
    Period.order(number: :desc).pluck(:number)
  end

  def name
    number
  end
end
