class TimeReport
  attr_reader :personalcharges
  attr_reader :p_total
  attr_reader :p_currents
  attr_reader :p_cumulatives
  attr_reader :user_list      
  attr_reader :e_current
  attr_reader :e_cumulative
  attr_reader :billings
  attr_reader :b_total
  attr_reader :initialfee
  attr_reader :deduction
  attr_reader :bt
  attr_reader :UFA_fees
  attr_reader :UFA_total
  def initialize
    @personalcharges = Personalcharge.new
    @p_total = Personalcharge.new
    @p_currents = []
    @p_cumulatives = []   
    @user_list = []
     
    @e_current = []
    @e_cumulative = []
    @billings = Billing.new
    @b_total = Billing.new
    
    @initialfee = Initialfee.new
    @deduction  = Deduction.new
    @bt         = {}
    
    @UFA_fees ={}
    @UFA_total = Ufafee.new
  end
  
  def for_report(project, period)
    sql_condition       = " project_id = #{project.id} and period_id ='#{period.id}' "
    sql_condition2      = " project_id = #{project.id} and periods.ending_date <= '#{period.ending_date}' "
    sql_all_by_project  = " project_id = #{project.id} "
    sql_join            = " inner join users on personalcharges.user_id = users.id inner join periods on periods.id = period_id "
    sql_order           = " english_name "
    #person charges
    @personalcharges  = Personalcharge.joins(:period).where(sql_condition2 + "and state = 'approved'")
    @user_list = Personalcharge.find_by_sql("select distinct user_id, english_name, charge_rate, employee_number from personalcharges " + sql_join + 
        " where " + sql_all_by_project + " order by english_name" )
    for user in @user_list
      @p_currents     << sum_personalcharge(project.id, user.user_id, period, 1)
      @p_cumulatives  << sum_personalcharge(project.id, user.user_id, period, 0)   
    end                       
    @p_total = sum_personalcharge(project.id, nil, period, 0)

    #expenses
    @e_current     = sum_expense(project.id, period, 1)
    @e_cumulative  = sum_expense(project.id, period, 0)

  
    #billings
    @billings                 = Billing.joins(:period).where(sql_condition2)
    @b_total.service_billing  = Billing.includes(:period).where(sql_condition2).sum("service_billing") ||0
    @b_total.expense_billing  = Billing.includes(:period).where(sql_condition2).sum("expense_billing") ||0    
    @bt["current"]            = Billing.where(sql_condition).sum("business_tax")||0
    @bt["cumulative"]         = Billing.includes(:period).where(sql_condition2).sum("business_tax")||0 
    #initialfees
    @initialfee = Initialfee.where(sql_all_by_project).first || Initialfee.new
    @deduction  = Deduction.where(sql_all_by_project).first || Deduction.new
  
    #PFA and UFA
    @UFA_fees   = Ufafee.joins(:period).where(sql_condition2)
    @UFA_total.service_UFA  = Ufafee.includes(:period).where(sql_condition2).sum("service_UFA")||0
    @UFA_total.expense_UFA  = Ufafee.includes(:period).where(sql_condition2).sum("expense_UFA")||0
  end

  private  
  def sum_personalcharge(project_id = nil, user_id=nil, period=nil, flag = nil )
    sql_join          = " inner join periods on periods.id = period_id "
    sql_condition = " 1 and state = 'approved' "
    sql_condition += " and project_id = #{project_id}" unless project_id.nil?
    sql_condition += " and user_id = #{user_id} " unless user_id.nil?
    if flag == 1
      sql_condition += " and period_id = #{period.id} " unless period.nil?
    end
    
    if flag == 0
      sql_condition += " and periods.ending_date <= '#{period.ending_date}' " unless period.nil?
    end
    
    @p = Personalcharge.new
    @p.user_id = user_id
    
    @p.project_id = project_id                           
    @p.service_fee      = Personalcharge.joins(sql_join).where(sql_condition).sum("service_fee") ||0 
    @p.hours            = Personalcharge.joins(sql_join).where(sql_condition).sum("hours") ||0
    @p.reimbursement    = Personalcharge.joins(sql_join).where(sql_condition).sum("reimbursement") ||0
    @p.meal_allowance   = Personalcharge.joins(sql_join).where(sql_condition).sum("meal_allowance") ||0
    @p.travel_allowance = Personalcharge.joins(sql_join).where(sql_condition).sum("travel_allowance") ||0
    @p.updated_on       = Personalcharge.joins(sql_join).where(sql_condition).maximum("updated_on") || nil
    return @p
  end
    
  def sum_expense(project_id = nil, period=nil, flag = nil)
    sql_join          = " inner join periods on periods.id = period_id "
    sql_condition = " 1 "
    sql_condition += " and project_id = #{project_id}" unless project_id.nil?
    
    if flag == 1
      sql_condition += " and period_id = #{period.id} " unless period.nil?
    end
    
    if flag == 0
      sql_condition += " and periods.ending_date <= '#{period.ending_date}' " unless period.nil?
    end
    @e            = Expense.new
    @e.project_id = project_id                           
    @e.tickets            = Expense.joins(sql_join).where(sql_condition).sum("tickets") ||0
    @e.courrier           = Expense.joins(sql_join).where(sql_condition).sum("courrier") ||0
    @e.postage            = Expense.joins(sql_join).where(sql_condition).sum("postage") ||0
    @e.stationery         = Expense.joins(sql_join).where(sql_condition).sum("stationery") ||0
    @e.report_binding     = Expense.joins(sql_join).where(sql_condition).sum("report_binding") ||0
    @e.payment_on_be_half = Expense.joins(sql_join).where(sql_condition).sum("payment_on_be_half") ||0
    @e.commission         = Expense.joins(sql_join).where(sql_condition).sum("commission") ||0
    @e.outsourcing        = Expense.joins(sql_join).where(sql_condition).sum("outsourcing") ||0
    @e.updated_on         = Expense.joins(sql_join).where(sql_condition).maximum("updated_on") || nil
    return @e
  end
end