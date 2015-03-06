class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates   :charge_rate, numericality: true
  belongs_to  :person
  has_many    :bookings
  has_many    :projects, through: :bookings

  scope :employed, -> {where(status: 'Employed')}
end
