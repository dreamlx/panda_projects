class ReportsController < ApplicationController
  layout "layouts/application" ,  :except => [:export, :time_report,:expense_export, :personalcharge_export, :billing_export, :summary, :summary_by_user]
  def index
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

    billing_sql =   " select	PRJ.id as prj_id, PRJ.job_code            as job_code, "+
      "	        0     as Beg_service, "+
      "	        sum(B.service_billing)  as Service_billing,	"+  
      "	        0    as Beg_expense, "+
      "	        sum(B.expense_billing)  as Expense_billing,	"+
      "	        sum(B.business_tax)     as BT "+
      " from projects 		            as PRJ "+
      #" left join deductions 	        as I_D    on I_D.project_id = PRJ.id "+
      " left join billings 	            as B      on B.project_id = PRJ.id "+
      " left join periods on periods.id = B.period_id                       "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id "+
      " order by PRJ.job_code; "
    @billings = Billing.find_by_sql(billing_sql)

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
  
    fee_PFA_sql =
      " select 	PRJ.id as prj_id, PRJ.job_code as job_code, "+
      "	PRJ.service_PFA,"+
      "	0 as Beg_service_fee,"+
      "	sum(CHARGE.service_fee) as Service_fee,"+
      "	0 as Beg_PFA,"+
      "	sum(CHARGE.service_fee)/100*PRJ.service_PFA as PFA"+
      " from projects 		           as PRJ"+
      #" left join initialfees 	   as I_FEE  on I_FEE.project_id = PRJ.id"+
      #" left join deductions 	       as I_D    on I_D.project_id = PRJ.id"+
      " left join personalcharges    as CHARGE on CHARGE.project_id = PRJ.id"+
      " left join periods on periods.id = CHARGE.period_id"+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+

      " group by PRJ.id"+
      " order by job_code;"
    @service_pfa = Project.find_by_sql(fee_PFA_sql)
  
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
  
    @srecords ={}
    @i=0
    for record in Project.order('job_code')
    
      summaryRecord                 = Summary.new
      summaryRecord.id              = record.id.to_s
      summaryRecord.GMU             = record.GMU.title
      summaryRecord.job_code        = record.job_code
      summaryRecord.clien_name      = record.client.english_name unless record.client.nil?
      summaryRecord.job_Ref         = record.referring.english_name unless record.referring.nil?
      summaryRecord.job_Ptr         = record.partner.english_name unless record.partner.nil?
      summaryRecord.job_Mgr         = record.manager.english_name unless record.manager.nil?
      summaryRecord.service_line    = record.service_code.code
      summaryRecord.service_PFA     = record.service_PFA
      summaryRecord.expense_PFA     = record.expense_PFA
      summaryRecord.contract_number = record.contract_number
      summaryRecord.contracted_fee  = record.contracted_service_fee
      summaryRecord.contracted_expense = record.contracted_expense
      summaryRecord.project_status  = record.status.title if record.status
    
      for fee in @service_pfa
        if record.id.to_s == fee.prj_id.to_s
          summaryRecord.fees_Beg = fee.Beg_service_fee||0
          summaryRecord.fees_Cum = fee.Service_fee||0
          summaryRecord.fees_Sub = fee.Beg_service_fee.to_i + fee.Service_fee.to_i||0
   
          summaryRecord.PFA_Beg = fee.Beg_PFA||0
          summaryRecord.PFA_Cum = fee.PFA||0
          summaryRecord.PFA_Sub = fee.Beg_PFA.to_i + fee.PFA.to_i||0
        end
      end
    


      for billing in @billings
        if record.id.to_s == billing.prj_id.to_s
          summaryRecord.Billing_Beg = billing.Beg_service||0
          summaryRecord.Billing_Cum = billing.Service_billing||0
          summaryRecord.Billing_Sub = billing.Beg_service.to_i + billing.Service_billing.to_i||0
          summaryRecord.BT = billing.BT||0
        end
      end
      #summaryRecord.INVENTORY_BALANCE = 0
      #summaryRecord.INVPER = 0
      summaryRecord.INVENTORY_BALANCE = summaryRecord.fees_Cum.to_i - summaryRecord.PFA_Cum.to_i - summaryRecord.Billing_Cum.to_i
    
      if summaryRecord.contracted_fee == 0 || summaryRecord.Billing_Cum
        summaryRecord.INVPER = 0
      else  
        summaryRecord.INVPER = (summaryRecord.Billing_Cum.to_i / summaryRecord.contracted_fee )* 100 
      end
      @srecords["#{@i}"] = summaryRecord
      @i = @i +1
    end
  end
  
  def summary_by_user
    @q = Project.search(params[:q])
    @projects = @q.result      

    @period = Period.find_by_number(params[:q][:starting_date_gteq])
    billing_sql =   " select	PRJ.id as prj_id, PRJ.job_code            as job_code, "+
      "	        I_D.service_billing     as Beg_service, "+
      "	        sum(B.service_billing)  as Service_billing,	"+  
      "	        I_D.expense_billing     as Beg_expense, "+
      "	        sum(B.expense_billing)  as Expense_billing,	"+
      "	        sum(B.business_tax)     as BT "+
      " from projects 		            as PRJ "+
      " left join deductions 	        as I_D    on I_D.project_id = PRJ.id "+
      " left join billings 	            as B      on B.project_id = PRJ.id "+
      " right join periods on periods.id = B.period_id                       "+
      " where periods.ending_date <='#{@period.ending_date}'                                      "+
      " group by PRJ.id "+
      " order by PRJ.job_code; "
    @billings = Billing.find_by_sql(billing_sql)

  
    fee_PFA_sql =
      " select 	PRJ.id as prj_id, PRJ.job_code as job_code, "+
      "	PRJ.service_PFA,"+
      "	I_FEE.service_fee as Beg_service_fee,"+
      "	sum(CHARGE.service_fee) as Service_fee,"+
      "	I_D.service_PFA as Beg_PFA,"+
      "	sum(CHARGE.service_fee)/100*PRJ.service_PFA as PFA"+
      " from projects 		           as PRJ"+
      " left join initialfees 	   as I_FEE  on I_FEE.project_id = PRJ.id"+
      " left join deductions 	       as I_D    on I_D.project_id = PRJ.id"+
      " left join personalcharges    as CHARGE on CHARGE.project_id = PRJ.id"+
      " right join periods on periods.id = CHARGE.period_id"+
      " where periods.ending_date <='#{@period.ending_date}'"+

      " group by PRJ.id"+
      " order by job_code;"
    @service_pfa = Project.find_by_sql(fee_PFA_sql)

  
    @srecords ={}
    @i=0
    for record in @projects
    
      summaryRecord = Summary.new
      summaryRecord.id = record.id.to_s
      summaryRecord.GMU = record.GMU.title||""
      summaryRecord.job_code = record.job_code||""
      summaryRecord.clien_name = record.client.english_name||"" if record.client
      summaryRecord.job_Ref = record.referring.english_name||"" if record.referring
      summaryRecord.job_Ptr = record.partner.english_name||"" if record.partner
      summaryRecord.job_Mgr = record.manager.english_name||"" if record.manager
      summaryRecord.service_line = record.service_code.code||""
      summaryRecord.service_PFA = record.service_PFA||0
      summaryRecord.expense_PFA = record.expense_PFA||0
      summaryRecord.contract_number = record.contract_number||"--"
      summaryRecord.contracted_fee = record.contracted_service_fee||0
      summaryRecord.contracted_expense = record.contracted_expense||0
      summaryRecord.project_status = record.status.title||""
    
      for fee in @service_pfa
        if record.id.to_s == fee.prj_id.to_s
          summaryRecord.fees_Beg = fee.Beg_service_fee||0
          summaryRecord.fees_Cum = fee.Service_fee||0
          summaryRecord.fees_Sub = fee.Beg_service_fee.to_i + fee.Service_fee.to_i||0
   
          summaryRecord.PFA_Beg = fee.Beg_PFA||0
          summaryRecord.PFA_Cum = fee.PFA||0
          summaryRecord.PFA_Sub = fee.Beg_PFA.to_i + fee.PFA.to_i||0
        end
      end
    

    
      for billing in @billings
        if record.id.to_s == billing.prj_id.to_s
          summaryRecord.Billing_Beg = billing.Beg_service||0
          summaryRecord.Billing_Cum = billing.Service_billing||0
          summaryRecord.Billing_Sub = billing.Beg_service.to_i + billing.Service_billing.to_i||0
          summaryRecord.BT = billing.BT||0
        end
      end

      summaryRecord.INVENTORY_BALANCE = summaryRecord.fees_Cum.to_i - summaryRecord.PFA_Cum.to_i - summaryRecord.Billing_Cum.to_i
    
      if summaryRecord.contracted_fee == 0
        summaryRecord.INVPER = 0
      else  
        summaryRecord.INVPER = (summaryRecord.Billing_Cum.to_i / summaryRecord.contracted_fee )* 100 
      end
      @srecords["#{@i}"] = summaryRecord
      @i = @i +1
    end
 
  end
  
  private
    def personalcharge_params
      params.require(:personalcharge).permit(:hours, :service_fee, :reimbursement, :meal_allowance, :travel_allowance, :project_id, :period_id, :PFA_of_service_fee, :person_id)
    end
    def get_summary_record(params_info,period)
      summary_record = {
        'id'  => "",
        'GMU' => "",
        'job_code' => "",
        'clien_name' => "",
        'job_Ref' => "",
        'job_Ptr' => "",
        'job_Mgr' => "",
        'service_line' => "",
        'service_PFA' => "",
        'contracted_fee' => "",
        'contracted_expense' => "",
        'project_status' => "",
        'fees_Beg' => 0,
        'fees_Cum' => 0,
        'fees_Sub' => 0,
        'PFA_Beg' => 0,
        'PFA_Cum' => 0,
        'PFA_Sub' => 0,        
        'Billing_Beg' => 0,	
        'Billing_Cum' => 0,	
        'Billing_Sub' => 0,	        	
        'BT' => 0,    
        'INVENTORY_BALANCE' =>""    
      }
       
      @info = params_info
      @projects = Project.find(:all)
      @now_period = Period.find(period)
    end
end
