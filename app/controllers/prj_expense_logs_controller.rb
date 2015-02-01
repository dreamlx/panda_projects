class PrjExpenseLogsController < ApplicationController
  def index
    @prj_expense_log_pages, @prj_expense_logs = paginate :prj_expense_logs
  end

  def show
    @prj_expense_log = PrjExpenseLog.find(params[:id])
  end

  def new
    @prj_expense_log = PrjExpenseLog.new
  end

  def create
    @prj_expense_log = PrjExpenseLog.new(prj_expense_log_params)
    if @prj_expense_log.save
      redirect_to prj_expense_logs_url, notice: 'PrjExpenseLog was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit
    @prj_expense_log = PrjExpenseLog.find(params[:id])
  end

  def update
    @prj_expense_log = PrjExpenseLog.find(params[:id])
    if @prj_expense_log.update(prj_expense_log_params)
      redirect_to @prj_expense_log, notice: 'PrjExpenseLog was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    PrjExpenseLog.find(params[:id]).destroy
    redirect_to prj_expense_logs_url
  end

  private
    def prj_expense_log_params
      params.require(:prj_expense_log).permit(:prj_id, :expense_id, :period_id, :other)
    end
end
