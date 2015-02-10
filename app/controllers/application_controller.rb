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
    
    def get_now_period
      cookie_period_id = cookies[:the_time]
      if cookie_period_id != "" 
        sql_condition  = " id = '#{cookie_period_id}'" 
      else
        sql_condition = "id = 0"
      end
      now_period = Period.where(sql_condition ).first || Period.today_period
      
      return now_period
    end

    def billing_number_set
      @billing_number = Dict.find_by_category('billing_number')
      @number = @billing_number.code.to_i + 1
      
      if @number <10 
        @str_number = "000" + @number.to_s
      elsif @number <100
        @str_number = "00" + @number.to_s
      elsif @number <1000
        @str_number = "0" + @number.to_s
      else 
        @str_number = @number.to_s
      end  
    end 
end
