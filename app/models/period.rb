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
    today = Time.now.strftime("%Y-%m-%d")
    period_sql = " 1 and '#{today}' <= ending_date and '#{today}' >= starting_date"
    return where(period_sql).first || order(number: :desc).first
  end
end
