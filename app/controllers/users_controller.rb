class UsersController < ApplicationController
  def add_user
    @people =Person.find(:all, :order => 'english_name')  
    if request.get?
      @user = User.new
    else
      @user = User.new(user_params)
    end
    if @user.save
      redirect_to_index("User #{@user.name} created")
    end
  end

  def edit
    @user =User.find(params[:id])
    @user.password ="******"
    @people =Person.find(:all, :order => 'english_name')   
  end

  def update
    @user =User.find(params[:id]) 
    if @user.update(user_params)
      redirect_to :action => 'list', notice: 'Industry was successfully updated.'
    else
      @people =Person.order('english_name')
      render 'edit'
    end
  end
    
  def list
    @vals = session[:other1].split
    @user_pages, @users = paginate :users
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    
  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(user_params)
      logged_in_user = @user.try_to_login
      
      if logged_in_user
        session[:user_id]       = logged_in_user.person_id  
        session[:login_user_id] = logged_in_user.id
        session[:other1]        = logged_in_user.other1
        
          
        redirect_to users_url
        #expense 在每月一号需要创建一个report_biding项目 100元
        #1判断当前period是否已经创建过update日志
        now_period = Period.today_period
        unless Dict.where(title: now_period.number).first
          expense_log = Dict.create(category: "expense_log", code: '1', title: now_period.number)
          
          projects = Project.includes(:status).where(title: 'Active')
          prj_count =0
          for project in projects
            if project.service_code.code.to_i >= 60 and project.service_code.code.to_i <=68
              add_expense_observer(project.job_code,100,"job_code in 60-68 add 100RMB|"+ now_period.number)
              prj_count +=1
            end
          end
          flash[:notice] = "expenses updated by auto_add_observer|" + now_period.number.to_s+"|records="+ prj_count.to_s

        end
        #add_expense_observer(job_code,100,"job_code in 60-68 add 100")
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end  
  end

  def logout
    session[:user_id] = nil
    cookies[:the_time] = ""
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")  
  end
  
  def peferences
  
  end
  
  def index
    @periods = Period.order(:number)
    @now_period = get_now_period
    @last_login = Dict.new
    @last_login = Dict.find_by_category('billing_number')

    #billings number
    today = Time.now
    if @last_login.title != today.strftime("%Y%m%d")
      @last_login.title = today.strftime("%Y%m%d")
      @last_login.code =0
      if @last_login.save
        flash[:notice] = "Today: you are the first login user"
      end
      #update_days_of_ageing
      Billing.update_all(days_of_ageing: (to_days(Time.now()) - to_days(billing_date)), status: 0)
    end
  end
  
  def create_cookie
    cookies[:the_time] = params[:period]
    redirect_to :action =>"index"
  end

  private
    def user_params
      params.require(:user).permit(:name, :person_id, :hashed_password, :auth, :other1, :other2, :password)
    end
end
