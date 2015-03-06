class TimeReportsController < ApplicationController
  def index
    @q = Project.search(params[:q])
    @reports = Report.page(params[:page])
  end

  def time_report                   
    @project = Project.find(params[:personalcharge][:project_id])
    @period = Period.find(params[:personalcharge][:period_id])
    
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
    @people       = Person.order('english_name')
    @start_period = Period.find(params[:period][:start_period_id])
    @end_period   = Period.find(params[:period][:end_period_id])
    @projects     = Project.order('job_code')
 
    reimb_sql = "select 	 PRJ.id as prj_id, PRJ.job_code as job_code,                          "+
      "          0 as Beg_travel,                 "+
      "	         0 as Beg_meal,                  "+
      "	         0 as Beg_per_dium,            "+
      "	sum(CHARGE.reimbursement) as cum_travel,                    "+
      "	sum(CHARGE.meal_allowance) as cum_meal,                     "+
      "	sum(CHARGE.travel_allowance) as cum_per_dium                "+
      " from projects 		as PRJ                                  "+
      #" left join initialfees 	  as I_FEE  on I_FEE.project_id = PRJ.id            "+
      " left join personalcharges as CHARGE on CHARGE.project_id = PRJ.id           "+
      " left join periods on periods.id = CHARGE.period_id                         "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id                                                       "+
      " order by job_code; "
    @reimbs = Expense.find_by_sql(reimb_sql)
  
    expense_sql = " select 	PRJ.id as prj_id, "+
      "           PRJ.job_code as job_code,                         "+
      "	( 	0 +      "+
      "		0 +             "+
      "		0 + 0         "+
      "	) as Beg_expense,                                         "+
      "	sum(E.tickets) as Ticket,                                 "+
      "	sum(E.courrier) as Courrier,                              "+
      "	sum(E.postage) as Postage,                                "+
      "	sum(E.stationery) as Stationery,                          "+
      "	sum(E.report_binding) as Report_binding,                  "+
      "	sum(E.payment_on_be_half) as Payment_on_be_half,          "+
      "	(	sum(E.tickets) + sum(E.courrier) +                    "+
      "		sum(E.postage) + sum(E.stationery) +                  "+
      "		sum(E.report_binding) + sum(E.payment_on_be_half)     "+
      "	) as Sub_expense                                          "+
      " from projects 		as PRJ                                "+
      #" left join initialfees 	  as I_FEE  on I_FEE.project_id = PRJ.id   "+
      " left join expenses 	  as E      on E.project_id = PRJ.id           "+
      " left join periods on periods.id = E.period_id                       "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id                                                       "+
      " order by job_code;                                                          "
    @expenses = Expense.find_by_sql(expense_sql)            

    ufa_sql = "select 	PRJ.id as prj_id, PRJ.job_code as job_code,     "+
      "	0 as Beg_service,           "+
      "	sum(U.service_UFA) as Service_UFA,     "+
      "	0 as Beg_expense,           "+
      "	sum(U.expense_UFA) as Expense_UFA     "+
      " from projects 		as PRJ            "+
      #" left join deductions 	  as I_D    on I_D.project_id = PRJ.id  "+
      " left join ufafees 	as U	on U.project_id = PRJ.id            "+
      " group by PRJ.id "+
      " order by job_code; "
    @ufas = Ufafee.find_by_sql(ufa_sql)
  
    co_sql = 
      " select PRJ.id as prj_id, PRJ.job_code, "+
      " 0 as CO_Beg, "+
      " sum(E.commission)       as commission, sum(E.outsourcing) as outsourcing"+
      " from projects as PRJ"+
      #" left join initialfees     as I_FEE on I_FEE.project_id = PRJ.id"+
      " left join expenses        as E on E.project_id = PRJ.id "+
      " left join periods on periods.id = E.period_id                       "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id"+
      " order by job_code;"
    @co_fees = Commission.find_by_sql(co_sql)
  
    @srecords = Array.new
    for record in Project.order('job_code')
      summaryRecord                 = Summary.new
      summaryRecord.id              = record.id.to_s
      summaryRecord.GMU             = record.GMU.title
      summaryRecord.job_code        = record.job_code
      summaryRecord.client_name     = record.client.english_name if record.client
      summaryRecord.job_Ref         = record.referring.english_name if record.referring
      summaryRecord.job_Ptr         = record.partner.english_name if record.partner
      summaryRecord.job_Mgr         = record.manager.english_name if record.manager
      summaryRecord.budgeted_service_fee = record.budgeted_service_fee
      summaryRecord.budgeted_expense = record.budgeted_expense
      summaryRecord.service_line    = record.service_code.code
      summaryRecord.service_PFA     = record.service_PFA
      summaryRecord.expense_PFA     = record.expense_PFA
      summaryRecord.estimated_commision = record.estimated_commision
      summaryRecord.estimated_outsorcing = record.estimated_outsorcing
      summaryRecord.contract_number = record.contract_number
      summaryRecord.contracted_fee  = record.contracted_service_fee
      summaryRecord.contracted_expense = record.contracted_expense
      summaryRecord.project_status  = record.status.title if record.status
      summaryRecord.created_on  = record.created_on
      summaryRecord.fees_Beg = record.initialfee.service_fee if record.initialfee
      summaryRecord.fees_Cum = record.personalcharges.sum(:service_fee)
      summaryRecord.fees_Sub = (summaryRecord.fees_Beg + summaryRecord.fees_Cum).to_i
      summaryRecord.PFA_Beg = record.deduction.service_PFA if record.deduction
      summaryRecord.PFA_Cum = (record.personalcharges.sum(:service_fee)/100 * (record.service_PFA))
      summaryRecord.PFA_Sub = (summaryRecord.PFA_Beg + summaryRecord.PFA_Cum).to_i

      summaryRecord.Billing_Beg = record.deduction.service_billing if record.deduction
      summaryRecord.Billing_Cum = record.billings.sum(:service_billing)
      summaryRecord.Expense_Cum - record.billings.sum(:expense_billing)
      summaryRecord.Billing_Sub = (summaryRecord.Billing_Beg + summaryRecord.Billing_Cum).to_i
      summaryRecord.BT = record.billings.sum(:business_tax)

      summaryRecord.INVENTORY_BALANCE = summaryRecord.fees_Cum.to_i - summaryRecord.PFA_Cum.to_i - summaryRecord.Billing_Cum.to_i    
      summaryRecord.INVPER =  (summaryRecord.contracted_fee == 0)? 0 : (summaryRecord.Billing_Cum.to_i / summaryRecord.contracted_fee )* 100 

      @srecords << summaryRecord
    end
  end
  
  def summary_by_user    
    @q = Project.search(params[:q])
    @projects = @q.result  
    
    @srecords = Array.new
    for record in @projects    
      summaryRecord                     = Summary.new
      summaryRecord.id                  = record.id.to_s
      summaryRecord.GMU                 = record.GMU.title
      summaryRecord.job_code            = record.job_code
      summaryRecord.client_name         = record.client.english_name if record.client
      summaryRecord.job_Ref             = record.referring.english_name if record.referring
      summaryRecord.job_Ptr             = record.partner.english_name if record.partner
      summaryRecord.job_Mgr             = record.manager.english_name if record.manager
      summaryRecord.service_line        = record.service_code.code
      summaryRecord.service_PFA         = record.service_PFA 
      summaryRecord.expense_PFA         = record.expense_PFA
      summaryRecord.contract_number     = record.contract_number
      summaryRecord.contracted_fee      = record.contracted_service_fee
      summaryRecord.contracted_expense  = record.contracted_expense
      summaryRecord.project_status      = record.status.title
    
      summaryRecord.fees_Beg = record.initialfee.service_fee if record.initialfee
      summaryRecord.fees_Cum = record.personalcharges.sum(:service_fee)
      summaryRecord.fees_Sub = (summaryRecord.fees_Beg + summaryRecord.fees_Cum).to_i
      summaryRecord.PFA_Beg = record.deduction.service_PFA if record.deduction
      summaryRecord.PFA_Cum = (record.personalcharges.sum(:service_fee)/100 * (record.service_PFA))
      summaryRecord.PFA_Sub = (summaryRecord.PFA_Beg + summaryRecord.PFA_Cum).to_i

      summaryRecord.Billing_Beg = record.deduction.service_billing if record.deduction
      summaryRecord.Billing_Cum = record.billings.sum(:service_billing)
      summaryRecord.Billing_Sub = (summaryRecord.Billing_Beg + summaryRecord.Billing_Cum).to_i
      summaryRecord.BT = record.billings.sum(:business_tax)

      summaryRecord.INVENTORY_BALANCE = summaryRecord.fees_Cum.to_i - summaryRecord.PFA_Cum.to_i - summaryRecord.Billing_Cum.to_i    
      summaryRecord.INVPER =  (summaryRecord.contracted_fee == 0)? 0 : (summaryRecord.Billing_Cum.to_i / summaryRecord.contracted_fee )* 100 

      @srecords << summaryRecord
    end
  end
end
