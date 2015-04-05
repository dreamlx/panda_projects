class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "admin"
      can :manage, :all
    elsif user.role == "hr"
      can :manage,                                Person
    else
      can [:new, :create],                        Personalcharge, :user_id => user.id
      can [:update, :destroy],                    Personalcharge, :user_id => user.id, :state => ["pending", "denied"]
      can [:new, :create, :show],                 Billing,        :user_id => user.id
      can [:update, :destroy],                    Billing,        :user_id => user.id, :status => "0"
      can [:new, :create],                        Expense,        :user_id => user.id
      can [:update, :destroy],                    Expense,        :user_id => user.id
      can [:new, :create, :edit, :update, :show], Client,         :user_id => user.id
      can [:read],                                Project,        :bookings => {user_id: user.id}
      can [:read],                                Person
    end
  end
end
