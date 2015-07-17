class UsersController < ApplicationController
  load_and_authorize_resource
  def index
    @q = User.search(params[:q])
    @users = @q.result
  end

  def new
    @user = User.new
    @roles = current_user.role == "hr_admin" ? User::USER_ROLES : User::USER_ROLES.reject{ |e| e == "hr_admin"}
  end

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @roles = current_user.role == "hr_admin" ? User::USER_ROLES : User::USER_ROLES.reject{ |e| e == "hr_admin"}
  end

  def update
    params[:user].delete(:password) if params[:user][:password].nil?
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(
        :email, :name, :person_id, :hashed_password, :auth, :other1, :other2, :password,
        :created_on, :updated_on, :chinese_name, :english_name, :employee_number, 
        :department, :grade, :charge_rate, :employeement_date, :address, :postalcode,
        :mobile, :tel, :extension, :gender, :status, :GMU, :role)
    end
end
