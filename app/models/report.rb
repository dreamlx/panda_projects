class Report < ActiveRecord::Base
  validates   :user_id,   presence: true
  validates   :period_id, presence: true
  validates   :period_id, uniqueness: {scope: :user_id}
  belongs_to  :user
  belongs_to  :period
  has_and_belongs_to_many :projects
  accepts_nested_attributes_for :projects, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  def self.additional_items
    { 
      "Public Holiday"            =>  "900LEV",
      "Regular Vacation"          =>  "901LEV",
      "Overtime Vacation Taken"   =>  "902LEV",
      "Approved Absence"          =>  "903LEV",
      "Illness"                   =>  "904LEV",
      "Statutory Leave"           =>  "905LEV",
      "No-pay Leave"              =>  "906LEV"
    }
  end
end