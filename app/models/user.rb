class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  USER_ROLES = ["admin", "hr", "hr_admin", "gm", "partner", "manager", "accounting", ""]
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:name]

  validates :name ,presence: true, uniqueness: { case_sensitive: false}
  # validates :role, inclusion: USER_ROLES
  # attr_accessor :name
  # validates   :charge_rate, numericality: true
  belongs_to  :person
  has_many    :bookings
  has_many    :projects, through: :bookings
  has_many    :billings
  has_many    :personalcharges

  scope :employed, -> {where(status: 'Employed')}

  def self.order_english_name
    User.order(:english_name).pluck(:english_name)
  end

  def email_required?
    false
  end
end
