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
      can :manage,              Project
      can :manage,              Booking
    elsif user.role == "hr_admin" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
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
    elsif user.role == "gm" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
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
    elsif user.role == "partner" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :read,                Billing
      can :read,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project do |project|
        project.bookings.where(user_id: user.id).any?
      end
      can [:index, :create, :update, :add_projects, :update_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can :show,                Report, :user_id => user.id
      can [:update],            Personalcharge
      can :manage,              Booking
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
    elsif user.role == "manager" && user.current_sign_in_ip.match(/192.168.(2|8|9).\d/)
      can :read,                Billing
      can :read,                Expense
      can [:read, :time_report],TimeReport
      can :show,                Project do |project|
        project.bookings.where(user_id: user.id).any?
      end
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
      can :read,                Report
      can [:read, :time_report], TimeReport
      can :read,                Client
      can :read,                Contact
      can :read,                Project
      can :read,                Ufafee
      can :read,                Dict
      can :read,                Booking
      can :read,                Industry
      can :read,                User
      can :read,                Personalcharge
      can :read,                Period
      can [:index, :create, :update, :add_projects, :update_projects, :fill_data, :submit], Report, :user_id => user.id
      can [:delete_project, :destroy], Report, :state => ['pending', 'denied'], :user_id => user.id
      can [:update],            Personalcharge
      can :json_data,           Report
      can [:edit_password, :update], User, :id => user.id
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
