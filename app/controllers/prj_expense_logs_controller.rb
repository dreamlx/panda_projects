class PrjExpenseLogsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = PrjExpenseLog.search(params[:q])
    @prj_expense_logs  = @q.result.page(params[:page]).per(200)
  end

  def destroy
    PrjExpenseLog.find(params[:id]).destroy
    redirect_to prj_expense_logs_path
  end
end