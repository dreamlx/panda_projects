class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :name, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
    end
  private
    def add_expense_observer(job_code,price=100,msg="")
      now_period = Period.today_period
      prj = Project.find_by_job_code(job_code)
      if prj.status.title == "Active"
        expense = Expense.create(project_id: prj.id, period_id: now_period.id, report_binding: price, memo: msg)
        PrjExpenseLog.create(period_id: now_period.id, prj_id: prj.id, expense_id: expense.id, other: ( prj.job_code + "|" + msg))
      end
    end
end
