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
      can :manage,              Industry
      # can :manage, :all
    elsif user.role == "hr"
      can :manage,              User
      can :manage,              Person
      can [:approve, :deny],    Report
      can :manage,              Personalcharge
    elsif user.role == "hr_admin"
      can :manage,              Billing
      can :manage,              Expense
      can [:read,:time_report], TimeReport
      can :manage,              Client
      can :manage,              Contact
      can :manage,              Project
      can :manage,              Ufafee
      can :manage,              Dict
      can :manage,              Industry
      can :manage,              User
      can :manage,              Person
      can [:approve, :deny],    Report
      can :manage,              Personalcharge
    elsif user.role == "gm"
      can :show,                Billing
      can :show,                Expense
      can :manage,              TimeReport
      can :read,                Client
      can :read,                User
      can :show,                Project
      can :index,               Personalcharge
      can [:read, :create, :update],  Dict
    elsif user.role == "partner"
      can :show,                Billing
      can :show,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project
      can [:create, :update, :add_projects, :fill_data, :submit], Report
    elsif user.role == "manager"
      can :show,                Billing
      can :show,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project
      can [:create, :update, :add_projects, :fill_data, :submit], Report
    elsif user.role == "accounting"
      can :show,                Billing
      can :show,                Expense
    else
      can [:create, :update, :add_projects, :fill_data, :submit], Report
    end
  end
end
