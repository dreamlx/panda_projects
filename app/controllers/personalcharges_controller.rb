class PersonalchargesController < ApplicationController
  def index
    @q = Personalcharge.search(params[:q])
    @personalcharges = @q.result.page(params[:page])

    @personalcharges_num    = @q.result.joins(:project).where("job_code REGEXP '^[0-9]'")
    @personalcharges_char   = @q.result.joins(:project).where("job_code REGEXP '^[a-z]'")
    @personalcharges_total  = @q.result
  end

  def new
    @personalcharge = Personalcharge.new
    @personalcharge.project_id = params[:project_id]
  end

  def create
    @personalcharge = Personalcharge.new(personalcharge_params)
    if @personalcharge.save
      redirect_to personalcharges_url, notice: 'Personalcharge was successfully created.'
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
      redirect_to personalcharges_url, notice: 'Personalcharge was successfully updated.'
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
        :created_on, :updated_on, :hours, :reimbursement, :meal_allowance,
        :travel_allowance, :project_id, :period_id, :person_id)
    end
end