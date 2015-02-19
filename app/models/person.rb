class Person < ActiveRecord::Base
  has_many    :projects
  has_many    :clients
  has_many    :personalcharges
  has_many    :commissions
  has_many    :outsourcings
  has_many    :billings
  has_one     :user
  has_many    :overtimes
  belongs_to  :GMU,        -> { where category: 'GMU' },            class_name: "Dict",  foreign_key: "GMU_id"
  belongs_to  :status,     -> { where category: 'person_status' },  class_name: "Dict",  foreign_key: "status_id"
  belongs_to  :gender,     -> { where category: 'gender' },         class_name: "Dict",  foreign_key: "gender_id"
  belongs_to  :department, -> { where category: 'department' },     class_name: "Dict",  foreign_key: "department_id"

  scope :workings, -> { where.not(status: 'resigned')}
  
  def self.selected_roles
    [['staff','staff'],['senior','senior'],['manager','manager'],['partner','partner'],['hr_admin','hr_admin'],['超级管理员','providence_breaker']]
  end

  def self.selected_users
    workings.order("english_name").map {|p| [ "#{p.english_name} || #{p.employee_number}", p.id ]}
  end

  def name
    english_name
  end
end
