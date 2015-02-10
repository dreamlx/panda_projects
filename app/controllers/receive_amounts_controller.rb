class ReceiveAmountsController < ApplicationController
  def new
    @billing = Billing.find(params[:billing_id])
    @receive_amount = @billing.receive_amounts.build
  end

  def create
    @billing = Billing.find(params[:billing_id])
    @receive_amount = @billing.receive_amounts.build(receive_amount_params)
    if @receive_amount.save
      redirect_to @billing, notice: 'ReceiveAmount was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @billing = Billing.find(params[:billing_id])
    @receive_amount = @billing.receive_amounts.find(params[:id])
  end

  def update
    @billing = Billing.find(params[:billing_id])
    @receive_amount = @billing.receive_amounts.find(params[:id])
    if @receive_amount.update(receive_amount_params)
      redirect_to @billing, notice: 'ReceiveAmount was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @billing = Billing.find(params[:billing_id])
    @billing.receive_amounts.find(params[:id]).destroy
    redirect_to @billing
  end

  private
    def receive_amount_params
      params.require(:receive_amount).permit(
        :created_on, :updated_on, :billing_id, :invoice_no, :receive_date,
        :receive_amount, :job_code)
    end
end
