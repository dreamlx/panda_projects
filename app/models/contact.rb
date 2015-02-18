class Contact < ActiveRecord::Base
  belongs_to :client
  validates :client_id, presence: true
  validates :name ,     presence: true
end
