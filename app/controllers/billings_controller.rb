class BillingsController < ApplicationController
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
    if @billing.status != '1'
      @billing_amount = ReceiveAmount.where(billing_id: @billing.id).sum(:receive_amount) || 0
      @billing.outstanding = @billing.amount - @billing_amount
      @billing.update(outstanding: @billing.outstanding)
      (@billing_amount == @billing.amount) ?  @billing.update(status: '1') : @billing.update(status: '0')
    else
      @billing.outstanding = 0
      @billing.update(outstanding: @billing.outstanding)
    end
  end

  def new
    init_set
    billing_number_set
    @type       = Dict.where(category: 'billing_type')
    @now_period = get_now_period
    @billing    = Billing.new(project_id: params[:id], number: (@billing_number.title + @str_number), period_id: @now_period.id)
  end

  def create
    @billing              = Billing.new(billing_params)
    @billing_number       = Dict.find_by_category('billing_number')
    @number               = @billing_number.code.to_i + 1
    @billing_number.code  = @number.to_s
        
    update_collection_days
    get_tax
    get_amount
    @billing.outstanding  = @billing.amount
    
    if @billing.save
      @billing_number.save
      redirect_to billings_url, id: @billing.project_id, notice: "#{@billing.project.job_code} -- Billing was successfully updated."
    else
      render 'new'
    end
  end

  def edit
    init_set
    @type = Dict.where(category: 'billing_type')
    
    @billing = Billing.find(params[:id])
    closed = true
    @projects.each do |project|
      closed = false if @billing.project_id == project.id
    end

    if closed == true
      flash[:notice] = 
      redirect_to :action => 'search', notice: "#{@billing.project.job_code}  -- project of the Billing  was closed."
    end
  end

  def update
    @billing = Billing.find(params[:id])
    if @billing.update(billing_params)
      get_tax
      get_amount
      outstanding_net = @billing.outstanding - @billing.write_off      
      @billing.status = '1' if outstanding_net == 0
      update_collection_days
      @billing.save
      redirect_to :action => 'show', :id => @billing, notice: "#{@billing.project.job_code}  -- Billing was successfully updated."
    else
      render :action => 'edit'
    end
  end

  def destroy
    Billing.find(params[:id]).destroy
    redirect_to billings_url
  end

  def search
    init_set
  	person_status = Dict.find_by_title_and_category("Resigned","person_status")
  	
  	@people = Person.where(" (grade like '%partner%' or grade like '%manager%' or grade like '%dir%') and status_id != '#{person_status.id}' ").order("english_name")
    @now_user = session[:user_id]
    person_id = params[:person_id]
  	@billing = Billing.new(billing_params) 
    @period =Period.new(params[:period])
    sql_str = " select D.job_code, A.* from "+ " billings as A, projects as D "+ " where A.project_id = D.id and "
    sql_condition = "  1 " 
    sql_order = " order by A.number "
    
    unless @period.ending_date.nil?
      sql_condition += " and billing_date <= '#{@period.ending_date}'"
    end

    unless @period.nil?
      sql_condition += " and billing_date >= '#{@period.starting_date}'  "
    end

    if not @billing.project_id.nil?
      sql_condition += " and project_id =#{ @billing.project_id} "
    end

    if not @billing.number.nil?
      sql_condition += " and number like '%#{ @billing.number.lstrip}%' "
    end
    
    if not @billing.status == ""
      sql_condition += " and status = '#{@billing.status}'"    
    end
	
    if @now_user != 0
      sql_condition += " and (billing_manager_id =#{@now_user} or billing_partner_id = #{@now_user}) "
    else
  		unless person_id.blank?
  			sql_condition += " and (billing_manager_id =#{person_id} or billing_partner_id = #{person_id}) "
  		end
  	end
    @billings = Billing.find_by_sql(sql_str + sql_condition + sql_order )
    @sql=sql_str + sql_condition + sql_order
    
    @p_sql = sql_str
    @p_condition = sql_condition
    @p_order = sql_order
    @sum_recieve_all =0
    for billing in @billings
      billing_recieve = ReceiveAmount.where('billing_id = ?', billing.id).sum('receive_amount')||0
      @sum_recieve_all += billing_recieve
    end

    join_sql =' inner join projects on projects.id = billings.project_id'
    @b_total = Billing.new
    @b_total.amount = Billing.sum("amount", :joins=>join_sql, :conditions => sql_condition)||0
    @b_total.outstanding = Billing.sum("outstanding", :joins=>join_sql, :conditions => sql_condition)||0
    @b_total.service_billing = Billing.sum("service_billing",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.expense_billing = Billing.sum("expense_billing",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.business_tax = Billing.sum("business_tax",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.write_off = Billing.sum("write_off",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.provision = Billing.sum("provision",:joins=>join_sql, :conditions => sql_condition)||0
    @b_count = Billing.count(:joins=>join_sql,:conditions =>sql_condition)    ||0
  end
    
  private
    def get_cookie
      @cookie_value = cookies[:the_time]
    end
    
    def get_tax
      tax_rate = 5.26/100
      @billing.business_tax = @billing.service_billing * tax_rate
    end
    
    def get_amount
      @billing.amount = @billing.service_billing + @billing.expense_billing
    end
    
    def update_collection_days
      if @billing.status == "1"
        @billing.collection_days = @billing.days_of_ageing
        @billing.outstanding =@billing.amount
      end
    end

    def billing_params
      params.require(:billing).permit(
        :created_on, :updated_on, :number, :billing_date,
        :person_id, :amount, :outstanding, :service_billing, :expense_billing,
        :days_of_ageing, :business_tax, :status, :collection_days, :project_id,
        :period_id, :write_off, :provision)
    end
end
