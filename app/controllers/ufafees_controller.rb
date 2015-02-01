class UfafeesController < ApplicationController
auto_complete_for :ufafee, :number
  def index
    sql = ' 1 '
    if !request.get?
      sql +=" and number like '%#{ufafee_params[:number]}%' "
    end
    @ufafee_pages, @ufafees = paginate :ufafees, :conditions=>sql
  end

  def show
    @ufafee = Ufafee.find(params[:id])
  end

  def new
    init_set  
    billing_number_set
    @ufafee = Ufafee.new(number: @billing_number.title + @str_number)
  end

  def create
    @billing_number = Dict.find(category: 'billing_number')
    @number = @billing_number.code.to_i + 1
    @billing_number.update(code: @number.to_s)
    @ufafee = Ufafee.new(ufafee_params)
    get_amount
    if @ufafee.save
      redirect_to ufafees_url, notice: 'Ufafee was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    init_set  
    @ufafee = Ufafee.find(params[:id])
  end

  def update
    @ufafee = Ufafee.find(params[:id])
    if @ufafee.update(ufafee_params)
    get_amount
    @ufafee.save
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
    def get_amount
      @ufafee.amount = @ufafee.service_UFA + @ufafee.expense_UFA
    end

    def ufafee_params
      params.require(:ufafee).permit(
        :created_on, :updated_on, :number, :amount, :project_id, :period_id, :service_UFA, :expense_UFA)
    end
end
