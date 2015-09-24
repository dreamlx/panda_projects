class Ufafee < ActiveRecord::Base
  validates :number, uniqueness: true
  belongs_to  :project
  belongs_to  :period
end
