class Personalcharge < ActiveRecord::Base
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
