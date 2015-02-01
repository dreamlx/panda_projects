class Client < ActiveRecord::Base
  validates :client_code,   uniqueness: true

  has_many    :projects
  belongs_to  :industry
  belongs_to  :person
  belongs_to  :category,  class_name: "Dict",   foreign_key: "category_id", -> { where category: 'client_category' }
  belongs_to  :status,    class_name: "Dict",   foreign_key: "status_id",   -> { where category: 'client_status' }
  belongs_to  :region,    class_name: "Dict",   foreign_key: "region_id",   -> { where category: 'region' }
  belongs_to  :gender1,   class_name: "Dict",   foreign_key: "gender1_id",  -> { where category: 'gender' }
  belongs_to  :gender2,   class_name: "Dict",   foreign_key: "gender2_id",  -> { where category: 'gender' }
  belongs_to  :gender3,   class_name: "Dict",   foreign_key: "gender3_id",  -> { where category: 'gender' }
end
