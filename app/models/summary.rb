class Summary
  attr_accessor :id,          :GMU,   
                :job_code,    :client_name,  
                :job_Ref,     :job_Ptr,
                :job_Mgr,     :service_line,            
                :service_PFA, :expense_PFA,
                :contract_number,
                :contracted_fee,
                :contracted_expense,
                :project_status,
                :fees_Beg,    :fees_Cum,
                :fees_Sub,    :PFA_Beg,
                :PFA_Cum,     :PFA_Sub,
                :Billing_Beg, :Billing_Cum,
                :Billing_Sub, :BT,
                :INVENTORY_BALANCE,
                :INVPER,
                :budgeted_service_fee, :budgeted_expense,
                :estimated_commision, :estimated_outsorcing, :created_on, :Expense_Cum

  def initialize
    @id  = ""
    @GMU = ""
    @job_code = ""
    @clien_name = ""
    @job_Ref = ""
    @job_Ptr = ""
    @job_Mgr = ""
    @service_line = ""
    @contract_number = ""
    @service_PFA = 0
    @expense_PFA = 0
    @contracted_fee = 0
    @contracted_expense = 0
    @project_status = ""
    @fees_Beg = 0
    @fees_Cum = 0
    @fees_Sub = 0
    @PFA_Beg = 0
    @PFA_Cum = 0
    @PFA_Sub = 0
    @Billing_Beg = 0
    @Billing_Cum = 0
    @Expense_Cum = 0
    @Billing_Sub = 0
    @BT = 0
        
    @INVENTORY_BALANCE = 0
    @INVPER= 0

    @estimated_commision = 0
    @budgeted_expense = 0
    @estimated_commision = 0
    @estimated_outsorcing = 0
    @created_on
  end
 
end