class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  attr_accessor :login

  validates :name ,presence: true, uniqueness: { case_sensitive: false}

  # validates   :charge_rate, numericality: true
  belongs_to  :person
  has_many    :bookings
  has_many    :projects, through: :bookings

  scope :employed, -> {where(status: 'Employed')}

  private
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        if conditions[:name].nil?
          where(conditions).first
        else
          where(name: conditions[:name]).first
        end
      end
    end
end
