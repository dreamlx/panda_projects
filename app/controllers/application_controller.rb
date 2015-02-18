class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize, :except => [:login]

  def authorize
    if session[:user_id].nil?
      flash[:notice] = "Please log in"
      redirect_to login_users_path
    end
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
