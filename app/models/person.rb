class Person < ActiveRecord::Base
  has_many    :projects
  has_many    :clients
  has_many    :personalcharges
  has_many    :commissions
  has_many    :outsourcings
  has_many    :billings
  has_one     :users
  has_many    :overtimes
  belongs_to  :GMU,        class_name: "Dict",  foreign_key: "GMU_id",        -> { where category: 'GMU' }
  belongs_to  :status,     class_name: "Dict",  foreign_key: "status_id",     -> { where category: 'person_status' }
  belongs_to  :gender,     class_name: "Dict",  foreign_key: "gender_id",     -> { where category: 'gender' }
  belongs_to  :department, class_name: "Dict",  foreign_key: "department_id", -> { where category: 'department' }
end
