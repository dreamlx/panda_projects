class ExpensesController < ApplicationController
  def index
    @q = Expense.ransack(params[:q])
    @expenses = @q.result.includes(:project, :period).order(updated_on: :desc).page(params[:page])
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
