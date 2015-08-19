class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "admin"
      can :manage,              Billing
      can :manage,              Expense
      can [:read,:time_report], TimeReport
      can :manage,              Client
      can :manage,              Contact
      can :manage,              Project
      can :manage,              Ufafee
      can :manage,              Dict
      can :manage,              Booking
      can :manage,              Industry
      can [:edit_password, :update], User, :id => user.id
      # can :manage, :all
    elsif user.role == "hr"
      can :manage,              User
      can :manage,              Person
      can [:index, :show, :approve, :deny],    Report
      can :manage,              Personalcharge
    elsif user.role == "hr_admin"
      can :manage,              Billing
      can :manage,              Expense
      # can [:read,:time_report], TimeReport
      can :manage,              TimeReport
      can :manage,              Client
      can :manage,              Contact
      can :manage,              Project
      can :manage,              Ufafee
      can :manage,              Dict
      can :manage,              Booking
      can :manage,              Industry
      can :manage,              User
      can :manage,              Person
      can [:index, :show, :approve, :deny],    Report
      can :manage,              Personalcharge
    elsif user.role == "gm"
      can :show,                Billing
      can :show,                Expense
      can :manage,              TimeReport
      can :read,                Client
      can :read,                User
      can :show,                Project
      can :index,               Personalcharge
      can :manage,              Booking
      can [:read, :create, :update],  Dict
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "partner"
      can :show,                Billing
      can :show,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project
      can [:index, :create, :update, :add_projects, :fill_data, :submit], Report, :user_id => user.id
      can :destroy,             Report, :state => ['pending', 'denied']
      can :show,                Report, :state => "approved", :user_id => user.id
      can :delete_project,      Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "manager"
      can :show,                Billing
      can :show,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project
      can [:index, :create, :update, :add_projects, :fill_data, :submit], Report, :user_id => user.id
      can :destroy,             Report, :state => ['pending', 'denied']
      can :show,                Report, :state => "approved", :user_id => user.id
      can :delete_project,      Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "accounting"
      can :show,                Billing
      can :show,                Expense
      can [:edit_password, :update], User, :id => user.id
    else
      can [:index, :create, :update, :add_projects, :fill_data, :submit], Report, :user_id => user.id
      can :destroy,             Report, :state => ['pending', 'denied']
      can :show,                Report, :state => "approved", :user_id => user.id
      can :delete_project,      Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    end
  end
end
