class ExpensesController < ApplicationController
  load_and_authorize_resource
  def index
    @q = params[:q] ? Expense.ransack(params[:q]) : Expense.ransack(project_id_eq: params[:project], period_number_gteq: params[:period_from], period_number_lteq: params[:period_to])
    if Expense::EXPENSE_NUMBER_FIELDS.include?(params[:col]) && !params[:col].empty?
      @expenses = @q.result.includes(:project, :period).where.not("#{params[:col]}": 0).page(params[:page])
    else
      @expenses = @q.result.includes(:project, :period).page(params[:page])
    end

    @expenses_total = @q.result
  end

  def new
    @expense = Expense.new
    if params[:project_id]
      @expense.project_id = params[:project_id]
    else
      @expense.project_id = Expense.last.project_id if Expense.last
    end
    @expense.period_id = Period.last.id if Period.last
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      @expense.update(user_id: current_user.id) if current_user
      redirect_to expenses_url, notice: 'Expense successfully created.'
    else
      render "new"
    end
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to expenses_url notice: 'Expense was successfully updated.'
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
