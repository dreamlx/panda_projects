class UfafeesController < ApplicationController
  def index
    @q = Ufafee.search(params[:q])
    @ufafees = @q.result.page(params[:page])
  end

  def show
    @ufafee = Ufafee.find(params[:id])
  end

  def new
    @ufafee = Ufafee.new
  end

  def create
    billing_number_set
    # update billing_number
    billing_number = Dict.find_by_category('billing_number')
    billing_number.update(code: (billing_number.code.to_i + 1).to_s)

    @ufafee = Ufafee.new(ufafee_params)
    if @ufafee.save
      @ufafee.update(
        number: (@billing_number.title + @str_number),
        amount: (@ufafee.service_UFA + @ufafee.expense_UFA))
      redirect_to ufafees_url, notice: 'Ufafee was successfully created.'
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
      redirect_to @ufafee, notice: 'Ufafee was successfully updated.'
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
      params.require(:ufafee).permit(
        :created_on, :updated_on, :number, :project_id, :period_id, :service_UFA, :expense_UFA)
    end
end
