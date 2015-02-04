class PersonalchargesController < ApplicationController
  def index
    @q = Personalcharge.search(params[:q])
    @personalcharges = @q.result.order(:project_id).page(params[:page])
  end

  def show
    @personalcharge = Personalcharge.find(params[:id])
  end

  def new
    @personalcharge = Personalcharge.new
  end

  def create
    @personalcharge = Personalcharge.new(personalcharge_params)
    if @personalcharge.save
      @personalcharge.update(service_fee: (hours * @personalcharge.person.charge_rate))  if @personalcharge.person.charge_rate
      redirect_to personalcharges_url, notice: 'Personalcharge was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    init_set
    @personalcharge = Personalcharge.find(params[:id])
  end

  def update
    @personalcharge = Personalcharge.find(params[:id])
    if @personalcharge.update(personalcharge_params)
      @personalcharge.update(service_fee: @personalcharge.hours * @personalcharge.person.charge_rate ) if @personalcharge.person.charge_rate
      redirect_to @personalcharge, notice: 'Personalcharge was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Personalcharge.find(params[:id]).destroy
    redirect_to personalcharges_url
  end

  private
    def personalcharge_params
      params.require(:personalcharge).permit(
        :created_on, :updated_on, :hours, :service_fee, :reimbursement, :meal_allowance,
        :travel_allowance, :project_id, :period_id, :person_id)
    end
end