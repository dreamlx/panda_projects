class Expense < ActiveRecord::Base
  belongs_to  :project
  belongs_to  :period
end
