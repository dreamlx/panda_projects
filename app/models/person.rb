class Person < ActiveRecord::Base
  has_many    :projects
  has_many    :clients
  has_many    :personalcharges
  has_many    :commissions
  has_many    :outsourcings
  has_many    :billings
  has_one     :users
  has_many    :overtimes
  belongs_to  :GMU,        -> { where category: 'GMU' },            class_name: "Dict",  foreign_key: "GMU_id"
  belongs_to  :status,     -> { where category: 'person_status' },  class_name: "Dict",  foreign_key: "status_id"
  belongs_to  :gender,     -> { where category: 'gender' },         class_name: "Dict",  foreign_key: "gender_id"
  belongs_to  :department, -> { where category: 'department' },     class_name: "Dict",  foreign_key: "department_id"
end
