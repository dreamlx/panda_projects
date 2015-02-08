class ClientsController < ApplicationController
  def index
    @q = Client.ransack(params[:q])
    @clients = @q.result.page(params[:page])
  end
  
  def new
    @client = Client.new                 
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_url
    else
      render 'new'
    end
  end
  
  def edit
    @client = Client.find(params[:id])                                                                                     
  end

  def show
    @client = Client.find(params[:id])
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