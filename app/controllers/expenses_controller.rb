class ExpensesController < ApplicationController
  def index
    @col_lists  = %w[commission outsourcing tickets courrier postage stationery report_binding cash_advance payment_on_be_half ]
    @col_list   = params[:col_list]
    
    @expense = Expense.new(expense_params)
    @expense.project_id = params[:prj_id] unless params[:prj_id].blank?
    @period_from = Expense.new(params[:period_from])
    @period_to = Expense.new(params[:period_to])

    str_order =" periods.number desc,expenses.updated_on desc "
    sql =" 1 "
    sql += " and project_id =#{ @expense.project_id} " unless @expense.project_id.nil?
    sql += " and memo like '%#{ @expense.memo}%' " unless @expense.memo.nil?
    sql += " and periods.number >='#{ @period_from.period.number}' " unless (@period_from.period_id.nil? or @period_from.period.nil?)
    sql += " and periods.number <='#{ @period_to.period.number}' " unless (@period_to.period_id.nil? or @period_to.period.nil?)
    sql += " and not #{@col_list} = 0 " if @col_list != "" and @col_list != nil
    @temp = sql
    @sum_expense = Expense.new
    @sum_expense.cash_advance       = Expense.sum(:cash_advance,      :include => :period,:conditions=>sql)
    @sum_expense.commission         = Expense.sum(:commission,        :include => :period,:conditions=>sql)
    @sum_expense.courrier           = Expense.sum(:courrier,          :include => :period,:conditions=>sql)
    @sum_expense.outsourcing        = Expense.sum(:outsourcing,       :include => :period,:conditions=>sql)
    @sum_expense.payment_on_be_half = Expense.sum(:payment_on_be_half,:include => :period,:conditions=>sql)
    @sum_expense.postage            = Expense.sum(:postage,           :include => :period,:conditions=>sql)
    @sum_expense.report_binding     = Expense.sum(:report_binding,    :include => :period,:conditions=>sql)
    @sum_expense.stationery         = Expense.sum(:stationery,        :include => :period,:conditions=>sql)
    @sum_expense.tickets            = Expense.sum(:tickets,           :include => :period,:conditions=>sql)
    @expenses = Expense.paginate  :page => params[:page], :order=>str_order,      :include => :period,      :conditions => sql
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def new
    @expense = Expense.new
    @expense.project_id = params[:prj_id]
    @expense.period_id = Period.order(number: :desc).first.id if Period.first
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to @expense, notice: _('%s was successfully created.', Expense.human_name)
    else
      render "new"
    end
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to @expense, notice: _('%s was successfully updated.', Expense.human_name)
    else
      render "edit"
    end
  end

  def destroy
    Expense.find(params[:id]).destroy
    redirect_to expenses_url
  end

  private
    def expense_params
      params.require(:expense).permit(
        :created_on, :updated_on, :commission, :outsourcing, :tickets, :courrier, :postage,
        :stationery, :report_binding, :cash_advance, :period_id, :project_id, 
        :payment_on_be_half, :memo)
    end
end
