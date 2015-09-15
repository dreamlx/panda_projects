class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "admin"
      can :manage,              Expense
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "hr"
      can :manage,              User
      can :manage,              Person
      can [:index, :show],    Report
      can :manage,              Personalcharge
      can :manage,              Project
      can :manage,              Booking
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
      can :manage,              Period
    elsif user.role == "gm"
      can :read,                Billing
      can :read,                Expense
      can :manage,              TimeReport
      can :read,                Client
      can :read,                User
      can :read,                Project do |project|
        project.bookings.where(user_id: user.id).any?
      end
      can :index,               Personalcharge
      can :manage,              Booking
      can [:read, :create, :update],  Dict
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "partner"
      can :read,                Billing
      can :read,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project do |project|
        project.bookings.where(user_id: user.id).any?
      end
      can [:index, :create, :update, :add_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :show, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "manager"
      can :read,                Billing
      can :read,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project do |project|
        project.bookings.where(user_id: user.id).any?
      end
      can [:index, :create, :update, :add_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :show, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "accounting"
      can :read,                Billing
      can :read,                Expense
      can :manage,              TimeReport
      can :read,                Project
      can :read,                Ufafee
      can :read,                Personalcharge
      can [:edit_password, :update], User, :id => user.id
    elsif user.role.empty?
      can [:index, :create, :update, :add_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :show, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    end
  end
end
