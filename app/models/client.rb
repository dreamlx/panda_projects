class Client < ActiveRecord::Base
  validates :client_code,   uniqueness: true

  has_many    :projects
  belongs_to  :industry
  belongs_to  :person
  belongs_to  :category,  -> { where category: 'client_category' }, class_name: "Dict",   foreign_key: "category_id"
  belongs_to  :status,    -> { where category: 'client_status' },   class_name: "Dict",   foreign_key: "status_id"   
  belongs_to  :region,    -> { where category: 'region' },          class_name: "Dict",   foreign_key: "region_id"   
  belongs_to  :gender1,   -> { where category: 'gender' },          class_name: "Dict",   foreign_key: "gender1_id"  
  belongs_to  :gender2,   -> { where category: 'gender' },          class_name: "Dict",   foreign_key: "gender2_id"
  belongs_to  :gender3,   -> { where category: 'gender' },          class_name: "Dict",   foreign_key: "gender3_id"

  def self.selected_clients
    order("english_name").map {|c| ["#{c.client_code} || #{c.english_name}", c.id ] }
  end
end
