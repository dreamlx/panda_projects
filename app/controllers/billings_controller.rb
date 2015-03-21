class BillingsController < ApplicationController
  load_and_authorize_resource :except => [:index]
  def index
    @q = Billing.search(params[:q])
    if current_user.role == "admin"
      @billings = @q.result.page(params[:page])
    else
      @billings = @q.result.where(user_id: current_user.id).page(params[:page])
    end
    @b_total = @q.result
    # @r_total = 0
    # @b_total.each do |b|
    #   @r_total += b.receive_amounts.sum(:receive_amount)
    # end
  end

  def show
    @billing = Billing.find(params[:id])
  end

  def new
    @billing    = Billing.new
    @billing.project_id = params[:project_id]
  end

  def create
    @billing              = Billing.new(billing_params)
    if @billing.status == "1"
      @billing.collection_days = @billing.days_of_ageing
      @billing.outstanding =@billing.amount
    end
    tax_rate = 5.26/100
    @billing.business_tax = @billing.service_billing * tax_rate
    @billing.amount = @billing.service_billing + @billing.expense_billing
    @billing.outstanding  = @billing.amount
    
    if @billing.save
      # update billing_number
      @billing_number       = Dict.find_by_category('billing_number')
      @billing_number.code  = (@billing_number.code.to_i + 1).to_s
      @billing_number.save
      # end of update billing_number
      redirect_to billings_url, id: @billing.project_id, notice: "#{@billing.project.job_code} -- Billing was successfully updated."
    else
      render 'new'
    end
  end

  def edit
    @billing = Billing.find(params[:id])
  end

  def update
    @billing = Billing.find(params[:id])
    if @billing.update(billing_params)
      tax_rate = 5.26/100
      @billing.business_tax = @billing.service_billing * tax_rate
      @billing.amount = @billing.service_billing + @billing.expense_billing
      @billing.status = '1' if @billing.outstanding == @billing.write_off      
      if @billing.status == "1"
        @billing.collection_days = @billing.days_of_ageing
        @billing.outstanding =@billing.amount
      end
      @billing.save
      redirect_to @billing, notice: "#{@billing.project.job_code}  -- Billing was successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    Billing.find(params[:id]).destroy
    redirect_to billings_url
  end
    
  private
    def billing_params
      params.require(:billing).permit(
        :created_on, :updated_on, :number, :billing_date,
        :person_id, :amount, :outstanding, :service_billing, :expense_billing,
        :days_of_ageing, :business_tax, :status, :collection_days, :project_id,
        :period_id, :write_off, :provision, :user_id)
    end
end
