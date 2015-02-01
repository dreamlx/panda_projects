class ClientsController < ApplicationController

  def index
    @client_pages, @clients = paginate :clients, :order_by => 'client_code'
    @statuses = Dict.where("category ='client_status'")
  end
  
  def new
    @client         = Client.new
    @industries     = Industry.all
    @categories     = Dict.where("category ='client_category'").order("code")
    @statuses       = Dict.where("category ='client_status'").order("code") 
    @regions        = Dict.where("category ='region'".order("code")
    @gender         = Dict.where("category ='gender'".order("code")
    @account_owners = Person.order('english_name')                   
  end
   def create
    @client         = Client.new(client_params)
    @industries     = Industry.find_all
    @categories     = Dict.where(                                :conditions =>"category ='client_category'",                                :order =>"code")
    @statuses       = Dict.where(                                :conditions =>"category ='client_status'",                                 :order =>"code") 
    @regions        = Dict.where(                                :conditions =>"category ='region'",                                 :order =>"code")
    @gender         = Dict.where(                                :conditions =>"category ='gender'",                                 :order =>"code")
    @account_owners = Person.order('english_name')  
    if @client.save
      redirect_to clients_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @client         = Client.find(params[:id])
    @industries     = Industry.all
    @categories     = Dict.where("category ='client_category'").order("code")
    @statuses       = Dict.where("category ='client_status'").order("code") 
    @regions        = Dict.where("category ='region'").order("code")
    @gender         = Dict.where("category ='gender'").order("code")
    @account_owners = Person.order('english_name')                                                                                       
  end
  
  def search
    @client = Client.new(client_params)
    sql = "1"
    sql += " and client_code like '%"+@client.client_code+"%' " if @client.client_code
    sql += " and chinese_name like '%"+@client.chinese_name+"%' " if @client.chinese_name
    if @client.client_code 
      @clients = Client.where(sql)
    else
      redirect_to clients_url
    end
  end

  private
    def client_params
      params.require(:client).permit(
        :chinese_name, :english_name, :person_id, :address_1, :person1, :person2, :address_2,
        :city_1, :city_2, :state_1, :state_2, :country_1, :country_2, :postalcode_1, :postalcode_2,
        :title_1, :title_2, :gender1_id, :gender2_id, :mobile_1, :mobile_2, :tel_1, :tel_2, 
        :fax_1, :fax_2, :email_1, :email_2, :description, :category_id, :status_id, :region_id,
        :industry_id, :client_code, :person3, :title_3, :gender3_id, :mobile_3, :tel_3, :fax_3,
        :email_3, :created_on, :updated_on)
    end
end