class BillingsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Billing.search(params[:q])
    @billings = @q.result.page(params[:page])
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
    @billing              = Billing.new
    @billing.project_id   = params[:project_id]
    @billing.period_id    = Period.last.id if Period.last
    @billing.user_id      = current_user.id if current_user
    @billing.billing_date = Date.today
    @billing.status       = "0"

    # update billing number mannually
    unless Dict.find_by(category: "billing_number", title: Date.today.strftime("%Y%m%d"))
      Dict.find_by(category: "billing_number").update(title: Date.today.strftime("%Y%m%d"), code: "0000")
    end
    billing_number        = Dict.find_by_category('billing_number')
    billing_number.code   = billing_number.code.succ
    billing_number.save
    # end of update

    @billing.number       = billing_number.title + billing_number.code
  end

  def create
    @billing              = Billing.new(billing_params)
    if @billing.status == "1"
      @billing.collection_days = @billing.days_of_ageing
      @billing.outstanding = @billing.amount
    end
    tax_rate = 5.26/100
    @billing.business_tax = @billing.service_billing * tax_rate
    @billing.amount = @billing.service_billing + @billing.expense_billing
    @billing.outstanding  = @billing.amount
    
    if @billing.save
      redirect_to billings_url, notice: "#{@billing.project.job_code} -- Billing was successfully updated."
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
