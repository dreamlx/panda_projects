class BillingsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Billing.search(params[:q])
    if current_user.role == "manager" || current_user.role == "partner" || current_user.role == "gm"
      @q.build_grouping({:m => 'or', :project_billing_manager_id_eq => current_user.id, :project_billing_partner_id_eq => current_user.id })
    end
    @billings = @q.result.page(params[:page])
    @b_total = @q.result
    # @r_total = 0
    # @b_total.each do |b|
    #   @r_total += b.receive_amounts.sum(:receive_amount)
    # end
  end

  def show
    @billing = Billing.find(params[:id])
    @receive_amounts = @billing.receive_amounts
    @num = @receive_amounts.count
    if @billing.status != '1'
      @billing_amount = @receive_amounts.sum(:receive_amount) ||0
      @billing.outstanding = @billing.amount - @billing_amount
      @billing.save
      if @billing_amount == @billing.amount
        @billing.status = '1'
        @billing.update(status: '1')
      else
        @billing.status = '0'  
        @billing.update(status: '0')
      end
    else
      @billing.outstanding = 0
      @billing.save
    end
  end

  def new
    @billing              = Billing.new
    if params[:project_id]
      @billing.project_id = params[:project_id]
    else
      @billing.project_id = Billing.last.project_id if Billing.last
    end
    @billing.period_id    = Period.last.id if Period.last
    @billing.user_id      = current_user.id if current_user
    @billing.billing_date = Date.today
    @billing.status       = "0"

    unless Dict.find_by(category: "billing_number", title: Date.today.strftime("%Y%m%d"))
      Dict.find_by(category: "billing_number").update(title: Date.today.strftime("%Y%m%d"), code: "0000")
    end
    billing_number        = Dict.find_by_category('billing_number')
    billing_number.code   = billing_number.code.succ
    @billing.number       = billing_number.title + billing_number.code
  end

  def create
    @billing              = Billing.new(billing_params)
    
    # update billing number mannually
    unless Dict.find_by(category: "billing_number", title: Date.today.strftime("%Y%m%d"))
      Dict.find_by(category: "billing_number").update(title: Date.today.strftime("%Y%m%d"), code: "0000")
    end
    billing_number        = Dict.find_by_category('billing_number')
    billing_number.code   = billing_number.code.succ
    # end of update

    @billing.collection_days = @billing.days_of_ageing if @billing.status == "1"
    tax_rate = 5.26/100
    @billing.business_tax = @billing.service_billing * tax_rate
    @billing.amount = @billing.service_billing + @billing.expense_billing
    @billing.outstanding  = @billing.amount
    
    if @billing.save
      @billing.update(number: billing_number.title + billing_number.code)
      billing_number.save
      redirect_to billings_url, notice: "#{@billing.number} -- Billing was successfully updated."
    else
      render 'new'
    end
  end

  def edit
    @billing = Billing.find(params[:id])
  end

  def update
    @billing = Billing.find(params[:id])
    return redirect_to @billing if @billing.status == '1'
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
