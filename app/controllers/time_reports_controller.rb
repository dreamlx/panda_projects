class TimeReportsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Project.search(params[:q])
  end

  def time_report
    @project = Project.find_by(job_code: params[:project_code])
    @period = Period.find_by(number: params[:period_number])
    
    @report = TimeReport.new
    @report.for_report(@project, @period)
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
    
    service_balance = service_total_charges - service_PFA - service_billing - service_UFA
    expense_balance = expense_total_charges - expense_PFA - expense_billing - expense_UFA
    
    if service_balance !=0 and  expense_balance != 0 #为0 允许close
      return false
    else
      true
    end
  end
  
  def summary
    periods_ids = Period.where("number >= ? AND  number <= ?",
                                params[:period][:start_period_number],
                                params[:period][:end_period_number]).ids
    @records = Array.new
    @projects = Project.order(:job_code)
    @projects.each do |project|
      @records << get_column(project, periods_ids)
    end
  end

  def summary_by_user
    periods_ids = Period.where("number >= ? AND  number <= ?",
                                params[:period][:start_period_number],
                                params[:period][:end_period_number]).ids
    @records = Array.new
    @q = Project.search(params[:q])
    @projects = @q.result.order(:job_code)
    @projects.each do |project|
      @records << get_column(project, periods_ids)
    end
  end

  private
    def get_column(project, periods_ids)
      personalcharges = project.personalcharges.approveds.where(period_id: periods_ids)
      expenses        = project.expenses.where(period_id: periods_ids)
      ufafees         = project.ufafees.where(period_id: periods_ids)
      billings        = project.billings.where(period_id: periods_ids)
      record = Hash.new
      record[:gmu]                    = project.GMU ? project.GMU.title : ""
      record[:job_code]               = project.job_code
      record[:client_name]            = project.client ? project.client.english_name : ""
      record[:job_ref]                = project.referring ? project.referring.english_name : ""
      record[:job_ptr]                = project.partner ? project.partner.english_name : ""
      record[:job_mgr]                = project.manager ? project.manager.english_name : ""
      record[:contract_number]        = project.contract_number
      record[:budgeted_service_fee]   = project.budgeted_service_fee
      record[:budgeted_expense_fee]   = project.budgeted_expense
      record[:service_PFA]            = project.service_PFA
      record[:expense_PFA]            = project.expense_PFA
      record[:estimated_commision]    = project.estimated_commision
      record[:estimated_outsorcing]   = project.estimated_outsorcing
      record[:contracted_serive_fee]  = project.contracted_service_fee
      record[:contracted_expense_fee] = project.contracted_expense
      record[:created_on]             = project.created_on
      record[:service_line]           = project.service_code ? project.service_code.code : ""
      record[:project_status]         = project.status ? project.status.title : ""

      # pfa
      record[:fee_beg]                = 0
      record[:fee_cum]                = personalcharges.sum(:service_fee) || 0
      record[:fee_sub]                = 0
      record[:PFA_rate]               = project.service_PFA
      record[:PFA_beg]                = 0
      record[:PFA_cum]                = personalcharges.sum(:service_fee)/100 * project.service_PFA
      record[:PFA_sub]                = 0

      # co-fee
      record[:co_beg]                 = 0
      record[:commission]             = expenses.sum(:commission) || 0
      record[:outsourcing]            = expenses.sum(:outsourcing) || 0
      record[:sub]                    = 0

      # reibur
      record[:traval_cum]             = personalcharges.sum(:reimbursement) || 0
      record[:meal_cum]               = personalcharges.sum(:meal_allowance) || 0
      record[:per_dium_cum]           = personalcharges.sum(:travel_allowance) || 0

      # expense
      record[:expense_beg]            = 0
      record[:ticket]                 = expenses.sum(:tickets) || 0
      record[:courrier]               = expenses.sum(:courrier) || 0
      record[:stationery]             = expenses.sum(:stationery) || 0
      record[:postage]                = expenses.sum(:postage) || 0
      record[:report_binding]         = expenses.sum(:report_binding) || 0
      record[:payment_on_be_half]     = expenses.sum(:payment_on_be_half) || 0

      # billing
      record[:billing_beg]            = 0
      record[:service_billing_cum]    = billings.sum(:service_billing) || 0
      record[:expense_billing_cum]    = billings.sum(:expense_billing) || 0
      record[:bt]                     = billings.sum(:business_tax) || 0
      record[:billing_sub]            = 0

      # ufa-fee
      record[:ufa_beg]                = 0
      record[:service_ufa_cum]        = ufafees.sum(:service_UFA) || 0
      record[:expense_ufa_cum]        = ufafees.sum(:expense_UFA) || 0
      return record
    end
end