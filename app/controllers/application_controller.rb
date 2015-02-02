class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize, :except => [:login]

  def authorize
    unless session[:user_id]
      flash[:notice] = "Please log in"
      redirect_to(:controller => "login", :action => "login")
    end
  end

  private
    def add_expense_observer(job_code,price=100,msg="")
      now_period = Period.today_period
      prj_status = Dict.find_by_title_and_category("Active","prj_status")
      prj = Project.find(:first,
        :conditions=>" 1 and (job_code like '%"+job_code+"%') and status_id =#{prj_status.id}")
      #需要判断项目是否已经关闭
      unless prj.nil?
        @expense = Expense.new
        @expense.project_id = prj.id
        @expense.period_id = now_period.id
        @expense.report_binding = price
        @expense.memo = msg
        @expense.save
        log = PrjExpenseLog.new
        log.period_id = now_period.id
        log.prj_id = prj.id
        log.expense_id = @expense.id
        log.other =( prj.job_code + "|" + msg)
        log.save
      end
    end
    
    def redirect_to_index(msg = nil)
      flash[:notice] = msg if msg
      redirect_to(:action => 'index')
    end
    
    def get_cookie
      return cookies[:the_time]
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
    
    def init_set
      prj_status = Dict.find_by_title_and_category("Active","prj_status")
      person_status = Dict.find_by_title_and_category("Resigned","person_status")
      @people = Person.where("status_id != '#{person_status.id}' ").order('english_name')
       
      @projects = Project.where(" status_id =#{prj_status.id}").order('job_code')
      @periods = Period.order('number DESC') 
      
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
