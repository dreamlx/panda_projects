class UsersController < ApplicationController 
  def index
    @q = User.search(params[:q])
    @users = @q.result.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_url
    else
      render 'new'
    end
  end

  def edit
    @user =User.find(params[:id])
  end

  def update
    @user =User.find(params[:id]) 
    if @user.update(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url
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
        
        redirect_to root_path
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
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    cookies[:the_time] = ""
    flash[:notice] = "Logged out"
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :person_id, :hashed_password, :auth, :other1, :other2, :password)
    end
end
