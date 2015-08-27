class Personalcharge < ActiveRecord::Base
  validates :hours,             numericality: true
  validates :service_fee,       numericality: true
  validates :reimbursement,     numericality: true
  validates :meal_allowance,    numericality: true
  validates :travel_allowance,  numericality: true
  validates :project_id,        presence: true
  validates :period_id,         presence: true
  # validates :user_id,           presence: true

  belongs_to :project
  belongs_to :period
  belongs_to :person
  belongs_to :user
  before_save :save_PFA_of_service_fee

  scope :approveds, -> {where(state: "approved")}

  state_machine :state, :initial => :pending do
    event :submit do
      transition [:pending, :denied] => :submitted
    end
    event :approve do
      transition :submitted  => :approved
    end
    event :deny do
      transition :submitted  => :denied
    end
  end

  def hours_replace
    hours == 0 ?  "--" : hours
  end

  def meal_allowance_replace
    meal_allowance == 0 ? "--" : meal_allowance
  end

  def travel_allowance_replace
    travel_allowance == 0 ? "--" : travel_allowance
  end

  def reimbursement_replace
    reimbursement == 0 ? "--" : reimbursement
  end

  def expense_sum
    reimbursement + meal_allowance + travel_allowance
  end


  private 
    def save_PFA_of_service_fee
      if self.user && self.user.charge_rate
        self.service_fee = self.hours * self.user.charge_rate
        if self.project && (self.project.service_PFA != 0)
          self.PFA_of_service_fee = (self.service_fee / 100) * self.project.service_PFA
        end
      end
      if self.person && self.person.charge_rate
        self.service_fee = self.hours * self.person.charge_rate
        if self.project && (self.project.service_PFA != 0)
          self.PFA_of_service_fee = (self.service_fee / 100) * self.project.service_PFA
        end
      end
    end
end
