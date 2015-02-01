class ReceiveAmountsController < ApplicationController
  def index
    @receive_amount_pages, @receive_amounts = paginate :receive_amounts
  end

  def show
    @receive_amount = ReceiveAmount.find(params[:id])
  end

  def new
    @billing = Billing.find(params[:id])
    @receive_amount = ReceiveAmount.new
  end

  def create
    @receive_amount = ReceiveAmount.new(receive_amount_params)
    if @receive_amount.save
      redirect_to :controller => 'billings', :action =>'show', :id => @receive_amount.billing_id, notice: 'ReceiveAmount was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @receive_amount = ReceiveAmount.find(params[:id])
    @billing = Billing.find(@receive_amount.billing_id)
  end

  def update
    @receive_amount = ReceiveAmount.find(params[:id])
    if @receive_amount.update(receive_amount_params)
      redirect_to :controller => 'billings', :action =>'show', :id => @receive_amount.billing_id, notice: 'ReceiveAmount was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    ReceiveAmount.find(params[:id]).destroy
    redirect_to :controller => 'billings', :action =>'show', :id => @receive_amount.billing_id
  end

  private
    def receive_amount_params
      params.require(:receive_amount).permit(
        :created_on, :updated_on, :billing_id, :invoice_no, :receive_date,
        :receive_amount, :job_code)
    end
end
