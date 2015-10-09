class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  USER_ROLES = ["admin", "hr", "hr_admin", "gm", "partner", "manager", "accounting", "it"]
  STATUS_TYPES = ["On leave", "Resigned", "Employed"]
  GMU_TYPES = ["Shanghai", "Beijing"]
  GENDER_TYPES = ["Male", "Female"]
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable,:session_limitable, :authentication_keys => [:name]

  validates :name ,presence: true, uniqueness: { case_sensitive: false}
  # validates :role, inclusion: USER_ROLES
  # attr_accessor :name
  # validates   :charge_rate, numericality: true
  # validates :status, inclusion: STATUS_TYPES
  belongs_to  :person
  has_many    :bookings
  has_many    :projects, through: :bookings
  has_many    :billings
  has_many    :personalcharges
  has_many    :reports

  scope :employed, -> {where(status: 'Employed').order(english_name: :asc)}

  def self.order_english_name
    User.employed.order(:english_name).pluck(:english_name)
  end

  def self.select_users
    Hash[User.employed.order(english_name: :asc).select("id,english_name").all.map{|u| [u.english_name, u.id]}]
  end

  def self.select_partners
    User.employed.where(role: 'partner').order(:english_name).pluck(:english_name)
  end

  def self.select_managers
    User.employed.where(role: 'manager').order(:english_name).pluck(:english_name)
  end

  def email_required?
    false
  end
end
