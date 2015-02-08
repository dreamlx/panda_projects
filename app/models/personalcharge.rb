class Personalcharge < ActiveRecord::Base
  validates :hours,             numericality: true
  validates :service_fee,       numericality: true
  validates :reimbursement,     numericality: true
  validates :meal_allowance,    numericality: true
  validates :travel_allowance,  numericality: true
  validates :project_id,        presence: true
  validates :period_id,         presence: true
  validates :person,            presence: true

  belongs_to :project
  belongs_to :period
  belongs_to :person
  before_save :save_PFA_of_service_fee

  private 
    def save_PFA_of_service_fee
      byebug
      self.PFA_of_service_fee = (self.project ? ((self.service_fee / 100) * self.project.service_PFA) : 0)
    end
end
