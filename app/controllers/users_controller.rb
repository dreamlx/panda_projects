class UsersController < ApplicationController 
  def index
    @q = User.search(params[:q])
    @users = @q.result.where.not(status: "Resigned")
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    params[:user].delete(:password) if params[:user].delete(:password).nil?
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
        :mobile, :tel, :extension, :gender, :status, :GMU, :role, :password)
    end
end
