class ProjectsController < ApplicationController
  def index
    @q = Project.search(params[:q])
    @projects = @q.result.includes(:status, :client, :partner, :manager).page(params[:page])
    @count = @q.result.count
  end

  def show
    @project = Project.find(params[:id])
    @initialfee = @project.initialfee ? @project.initialfee : @project.create_initialfee
    @deduction  = @project.deduction ? @project.deduction : @project.create_deduction
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    @project.job_code =@project.client.client_code+@project.GMU.code+@project.service_code.code if (@project.job_code || @project.job_code == "")
    if @project.save
      if (@project.service_code.code.to_i < 60 || @project.service_code.code.to_i >68) && @project.service_code.code.to_i != 100
        add_expense_observer(@project.job_code,250,"if prj code not in 60-68,then add 250")
      end
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.job_code.nil? or @project.job_code.blank?                      
      @project.job_code =@project.client.client_code+@project.GMU.code+@project.service_code.code
    end    
    if @project.update_attributes(project_params)
      redirect_to @project, notice: _('%s was successfully updated.', Project.human_name)
    else
      render "edit"
    end
  end
  
  def close
    closed_item = Dict.find_by_category_and_code('prj_status', '0')
    #需要判断balance是否为0，如果有结余！=0 则无法close
    allow_closed = is_balance(Project.find(params[:id]),Period.today_period)
    billings = Billing.where(project_id: params[:id])
    billing_number= "<br/>|need close billings --"
    for item in billings
      if item.status == "0"
        allow_closed = false
        billing_number = billing_number + item.number + " |"
      end
    end
    if allow_closed and Project.find(params[:id]).update_attribute(:status_id,closed_item.id)
      redirect_to projects_url, notice: "Poject was successfully closed"
    else
      flash[:notice] ="Poject error updated with projects"
      flash[:notice]=( "<font color=red>ballance is not 0!</font>" + "|service balance: #{ @service_balance.to_s}" +"|expense balance:"+ @expense_balance.to_s + billing_number) unless allow_closed
      redirect_to projects_url
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    redirect_to projects_url
  end
  
  private
    def is_balance(t_project,t_period)
      @statuses   = Dict.where("category ='prj_status' and code = '1'")# 1 open, 0 close
                     
      @project = t_project
      @now_period = t_period
      
      @report = TimeReport.new
      @report.for_report(@project, @now_period)
      #charges
      @personalcharges = @report.personalcharges
      @p_currents = @report.p_currents
      @p_cumulatives = @report.p_cumulatives
      @p_total  = @report.p_total
      @user_list = @report.user_list
      #expenses
      @e_current = @report.e_current
      @e_cumulative  = @report.e_cumulative
      sum_expenses = 0
      sum_e_total = 0
  				
      sum_expenses 	+= @e_current.courrier
      sum_e_total 	+= @e_cumulative.courrier
      sum_expenses 	+= @e_current.postage
      sum_e_total 	+= @e_cumulative.postage
      sum_expenses 	+= @e_current.payment_on_be_half
  	
      sum_expenses 	+= @e_current.report_binding
      sum_e_total 	+= @e_cumulative.report_binding
      sum_expenses 	+= @e_current.stationery
      sum_e_total 	+= @e_cumulative.stationery
      sum_expenses 	+= @e_current.tickets
      sum_e_total 	+= @e_cumulative.tickets
      sum_e_total 	+= @e_cumulative.payment_on_be_half
      #billings
      @billings  = @report.billings
      @billing_total   = @report.b_total
      @bt={}
      @bt        = @report.bt   
      sum_expenses 	+=@bt["current"]
      sum_e_total 	+=@bt["cumulative"]
      @sum_all_expenses = sum_expenses
      @sum_e_total    = sum_e_total  	
      #initialfees
      @initialfee = @report.initialfee
      @sum_initialfee = @initialfee.courrier + @initialfee.postage + 
        @initialfee.payment_on_be_half + @initialfee.report_binding +
        @initialfee.stationery + @initialfee.tickets + @initialfee.commission + 
        @initialfee.outsourcing + @initialfee.business_tax
      @initialdeduction = @report.deduction
      
      #PFA and UFA
      @UFA_fees  = @report.UFA_fees
      @UFA_total   = @report.UFA_total
      
      @total_reimbs =  @p_total.travel_allowance  + @p_total.reimbursement + @p_total.meal_allowance
      #计算
       
      service_total_charges = @p_total.service_fee + @initialfee.service_fee + @e_cumulative.outsourcing + @e_cumulative.commission
      expense_total_charges = @sum_e_total  +@total_reimbs + @sum_initialfee + @initialfee.meal_allowance + @initialfee.travel_allowance + @initialfee.reimbursement 
      
      service_PFA = (@p_total.service_fee )*@project.service_PFA/100 +@initialdeduction.service_PFA
      expense_PFA = (@total_reimbs+@sum_e_total-@e_cumulative.payment_on_be_half)*@project.expense_PFA/100 +@initialdeduction.expense_PFA
      
      service_billing =@billing_total.service_billing + @initialdeduction.service_billing
      expense_billing = @billing_total.expense_billing + @initialdeduction.expense_billing
      
      service_UFA = @UFA_total.service_UFA+@initialdeduction.service_UFA
      expense_UFA = @UFA_total.expense_UFA+@initialdeduction.expense_UFA
      
      @service_balance = service_total_charges - service_PFA - service_billing - service_UFA
      @expense_balance = expense_total_charges - expense_PFA - expense_billing - expense_UFA
      
      return ((@service_balance <1 and @service_balance >-1 ) and (@expense_balance <1  and @expense_balance >-1 ))#为0 允许close
    end

    def project_params
      params.require(:project).permit(
        :created_on, :updated_on, :contract_number, :client_id, :GMU_id, :service_id, :job_code, :description,
        :starting_date, :ending_date, :estimated_annual_fee, :risk_id, :status_id, :partner_id, :manager_id,
        :referring_id, :billing_partner_id, :billing_manager_id, :contract_service_fee, :estimated_commision,
        :estimated_outsourcing, :budgeted_service_fee, :service_PFA, :expense_PFA, :contracted_expense, 
        :budgeted_expense, :PFA_reason_id, :revenue_id )
    end
end
