class ExpensesController < ApplicationController
  load_and_authorize_resource :except => [:index]
  def index
    @q = Expense.ransack(params[:q])
    if current_user.role == "admin"
      @expenses = @q.result.includes(:project, :period).page(params[:page])
    else
      @expenses = @q.result.includes(:project, :period).where(user_id: current_user.id).page(params[:page])
    end

    @expenses_total = @q.result
  end

  def new
    @expense = Expense.new
    @expense.project_id = params[:project_id]
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
