class PeopleController < ApplicationController
  def index 
    @person = Person.new(person_params) 
    sql_condition = " 1 "
    sql_condition +=" and employee_number like '%#{@person.employee_number}%'" unless @person.employee_number.blank?
    sql_condition +=" and id = #{params[:person_id]}" unless params[:person_id].to_s == ''
    
    @sql = sql_condition
    @person_pages, @people = paginate :people,      :conditions=>sql_condition,      :order_by => "employee_number" 
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to people_url, notice: 'Person was successfully created.'
    else
      render 'new'
    end
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
      redirect_to  @person, notice: 'Person was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy if Person.find(params[:id]).english_name != "guest"
    redirect_to people_url
  end
  
  def new
    @person       = Person.new
    @dicts        = Dict.where("category ='GMU'")    
    @status       = Dict.where("category ='person_status'")
    @gender       = Dict.where("category ='gender'")
    @departments  = Dict.where("category ='department'")                      
  end
  
  def edit
    @person       = Person.find(@params[:id])
    @dicts        = Dict.where("category ='GMU'")    
    @status       = Dict.where("category ='person_status'")
    @gender       = Dict.where("category ='gender'")
    @departments  = Dict.where("category ='department'") 
  end
  
  def show
    @person       = Person.find(@params[:id])
    @dicts        = Dict.where("category ='GMU'")    
    @status       = Dict.where("category ='person_status'")
  end

  private
    def person_params
      params.require(:person).permit(
        :created_on, :updated_on, :chinese_name, :english_name, :employee_number, :department_id, :grade, :charge_rate,
        :employeement_date, :address, :postalcode, :mobile, :tel, :extension, :gender_id, :status_id, :GMU_id)
    end
end
