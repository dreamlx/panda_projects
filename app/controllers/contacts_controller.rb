class ContactsController < ApplicationController
  # load_and_authorize_resource
  def index
    @q = Contact.search(params[:q])
    @contacts  = @q.result
  end

  def create
    @client = Client.find(params[:client_id])
    @contact = @client.contacts.build(contact_params)
    if @contact.save
      redirect_to @client
    else
      render @client
    end
  end

  def update
    @contact = Contact.find(params[:id])
    
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact }
        format.json { respond_with_bip(@contact) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@contact) }
      end
    end
  end

  def destroy
    @client = Client.find(params[:client_id])
    @client.contacts.find(params[:id]).destroy
    redirect_to @client
  end

  private
    def contact_params
      params.require(:contact).permit(
        :client_id, :name, :title, :gender, 
        :mobile, :tel, :fax, :email, 
        :address, :city, :state, :country, :postalcode)
    end
end
