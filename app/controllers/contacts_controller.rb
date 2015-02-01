class ContactsController < ApplicationController
  def index
    @contact_pages, @contacts = paginate :contacts
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to contacts_url, notice: 'Contact was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      redirect_to :action => 'show', :id => @contact, notice: 'Contact was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Contact.find(params[:id]).destroy
    redirect_to contacts_url
  end

  private
    def contact_params
      params.require(:contact).permit(:client_id, :name, :title, :gender, :mobile, :tel, :fax, :email, :other)
    end
end
