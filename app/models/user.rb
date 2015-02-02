class User < ActiveRecord::Base
  validates   :name,      presence: true, uniqueness: true
  belongs_to  :person

  attr_accessor :password
  
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end

  def after_create
    @password = nil
  end

  def before_update
    self.hashed_password = User.hash_password(self.password) if self.password != '******'
  end
  
  def self.login(name, password)
    hashed_password = hash_password(password || "")
    where(name: name, hashed_password: hashed_password).first
  end

  def try_to_login
    User.login(self.name, self.password)
  end

    private
    def self.hash_password(password)
      Digest::SHA1.hexdigest(password)
    end
end
