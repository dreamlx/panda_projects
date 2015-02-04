class PrjExpenseLogsController < ApplicationController
  def index
    @prj_expense_logs = PrjExpenseLog.page(params[:page])
  end

  def destroy
    PrjExpenseLog.find(params[:id]).destroy
    redirect_to prj_expense_logs_url(page: params[:page])
  end
end
