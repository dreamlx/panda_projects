class InitialfeesController < ApplicationController
  def index
    @initialfees = Initialfee.joins("inner join projects on initialfees.project_id = projects.id ").order("projects.job_code").page(params[:page])
  end

  def show
    @initialfee = Initialfee.find(params[:id])
  end

  def new
    @initialfee = Initialfee.new(project_id: params[:id])
  end

  def create
    @initialfee = Initialfee.new(initialfee_params)
    if @initialfee.save
      redirect_to @initialfee, notice: 'Initialfee was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @initialfee = Initialfee.find(params[:id])
  end

  def update
    @initialfee = Initialfee.find(params[:id])
    if @initialfee.update(initialfee_params)
      redirect_to @initialfee, notice: 'Initialfee was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Initialfee.find(params[:id]).destroy
    redirect_to initialfees_url
  end

  private
    def initialfee_params
      params.require(:initialfee).permit(
        :created_on, :updated_on, :service_fee, :commission, :outsourcing, :reimbursement, :meal_allowance,
        :travel_allowance, :business_tax, :tickets, :courrier, :postage, :stationery, :report_binding, 
        :payment_on_behalf, :project_id, :cash_advance )
    end
end