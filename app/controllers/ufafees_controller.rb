class UfafeesController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Ufafee.search(params[:q])
    @ufafees = @q.result.page(params[:page])
  end

  def new
    @ufafee = Ufafee.new
    @ufafee.project_id = params[:project_id]
    @ufafee.period_id = Period.last.id
  end

  def create
    billing_number = Dict.find_by_category('billing_number')
    billing_number.update(code: (billing_number.code.to_i + 1).to_s.rjust(4, '0'))

    @ufafee = Ufafee.new(ufafee_params)
    if @ufafee.save
      @ufafee.update(
        number: (billing_number.title + billing_number.code),
        amount: (@ufafee.service_UFA + @ufafee.expense_UFA))
      redirect_to ufafees_url
    else
      render 'new'
    end
  end

  def edit
    @ufafee = Ufafee.find(params[:id])
  end

  def update
    @ufafee = Ufafee.find(params[:id])
    if @ufafee.update(ufafee_params)
      @ufafee.update(amount: (@ufafee.service_UFA + @ufafee.expense_UFA))
      redirect_to @ufafee
    else
      render 'edit'
    end
  end

  def destroy
    Ufafee.find(params[:id]).destroy
    redirect_to ufafees_url
  end
  
  private
    def ufafee_params
      params.require(:ufafee).permit(:number, :project_id, :period_id, :service_UFA, :expense_UFA)
    end
end
