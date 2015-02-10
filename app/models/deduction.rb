class Deduction < ActiveRecord::Base
  validates   :project_id,  presence: true
  # validates   :period_id,   presence: true
  
  belongs_to  :project
  belongs_to  :period
end
