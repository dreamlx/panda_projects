class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "admin" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :manage,              Expense
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "hr" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :manage,              User
      can :manage,              Person
      can [:index, :show],    Report
      can :manage,              Personalcharge
      can [:read, :update],     Project
      can :manage,              Booking
    elsif user.role == "hr_admin"
      can [:read, :edit, :update, :new, :create], Billing
      can :manage,              ReceiveAmount
      can :manage,              Expense
      can :manage,              TimeReport
      can :manage,              Client
      can :manage,              Contact
      can [:read, :edit, :update, :new, :create, :close], Project
      can [:read, :edit, :update, :new, :create], Ufafee
      can :manage,              Booking
      can :manage,              User
      can :manage,              Person
      can [:index, :show, :approve, :deny],    Report
      can :manage,              Personalcharge
    elsif user.role == "gm"
      can [:read,:destroy],     Billing
      can :read,                Expense
      can :manage,              TimeReport
      can :read,                Client
      can :read,                User
      can [:read, :destroy, :open],    Project
      can [:read, :destroy],    Ufafee
      can :index,               Personalcharge
      can :manage,              Booking
      can [:read, :create, :update],  Dict
      can [:edit_password, :update], User, :id => user.id
      can :manage,              Dict
      can :manage,              Industry
      can :manage,              Period
    elsif user.role == "partner"
      can :read,                Billing
      can [:read, :time_report],TimeReport
      can [:index, :create, :update, :add_projects, :update_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can :show,                Report, :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "manager" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :read,                Billing
      can [:read, :time_report],TimeReport
      can [:index, :create, :update, :add_projects, :update_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can :show,                Report, :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "accounting" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :read,                Billing
      can :read,                Expense
      can :manage,              TimeReport
      can :read,                Project
      can :read,                Ufafee
      can :read,                Personalcharge
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "it" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :read,                Billing
      can :read,                Expense
      can :read,                Project
      can :read,                Ufafee
      can :read,                Dict
      can :read,                Booking
      can :read,                Industry
      can :read,                User
      can :read,                Personalcharge
      can :read,                Period
      can [:update],            Personalcharge
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "administrator" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :manage,              :all
    elsif user.role.nil? || user.role.empty? || (user.current_sign_in_ip.match(/192.168.18.(230|2[0-2][0-9]|1[0-9][0-9])/) && (user.role == "manager" || user.role == "partner"))
      can [:index, :create, :update, :add_projects, :update_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can :show,                Report, :user_id => user.id
      can [:update],            Personalcharge
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    end
  end
end
