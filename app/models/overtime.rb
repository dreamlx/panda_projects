class Overtime < ActiveRecord::Base
  belongs_to  :ot_type, class_name: "Dict", foreign_key: "ot_type_id",  -> { where category: 'ot_type' }
  belongs_to  :person
end
