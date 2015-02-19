class Commission < ActiveRecord::Base
  belongs_to  :project
  belongs_to  :period
  belongs_to  :person
  belongs_to  :user
end
