class PersonalchargesController < ApplicationController
  def index
    @q = Personalcharge.search(params[:q])
    @personalcharges = @q.result.page(params[:page])

    @personalcharges_num    = @q.result.joins(:project).where("job_code REGEXP '^[0-9]'")
    @personalcharges_char   = @q.result.joins(:project).where("job_code REGEXP '^[a-z]'")
    @personalcharges_total  = @q.result
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
      @personalcharge.update(service_fee: (@personalcharge.hours * @personalcharge.person.charge_rate))  if @personalcharge.person.charge_rate
      redirect_to @personalcharges, notice: 'Personalcharge was successfully created.'
    else
      render 'new'
    end
  end

  def edit
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