class UsersController < ApplicationController 
  def index
    @q = User.search(params[:q])
    @users = @q.result
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_url
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :name, :person_id, :hashed_password, :auth, :other1, :other2, :password,
        :created_on, :updated_on, :chinese_name, :english_name, :employee_number, 
        :department, :grade, :charge_rate, :employeement_date, :address, :postalcode,
        :mobile, :tel, :extension, :gender, :status, :GMU, :role)
    end
end
