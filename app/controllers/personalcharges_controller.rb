class PersonalchargesController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Personalcharge.search(params[:q])
    @personalcharges = @q.result.page(params[:page]).order(id: :desc)

    @personalcharges_num    = @q.result.joins(:project).where("job_code REGEXP '^[0-9]'")
    @personalcharges_char   = @q.result.joins(:project).where("job_code REGEXP '^[a-z]'")
    @personalcharges_total  = @q.result
    respond_to do |format|
      format.html
      format.xls { send_data @personalcharges_total.to_xls, content_type: 'application/vnd.ms-excel', filename: "#{DateTime.now.to_s(:number)}personalcharges.xls" }
    end
  end

  def new
    @personalcharge = Personalcharge.new
    @personalcharge.project_id = params[:project_id]
    @personalcharge.period_id = Period.last.id if Period.last
    @personalcharge.user_id = current_user.id
  end

  def create
    @personalcharge = Personalcharge.new(personalcharge_params)
    if @personalcharge.save
      redirect_to personalcharges_url
    else
      render 'new'
    end
  end

  def edit
    @personalcharge = Personalcharge.find(params[:id])
  end

  def update
    @personalcharge = Personalcharge.find(params[:id])

    respond_to do |format|
      if @personalcharge.update(personalcharge_params)
        @personalcharge.update(service_fee: @personalcharge.hours * @personalcharge.user.charge_rate) if @personalcharge.user.charge_rate
        format.html { redirect_to personalcharges_url }
        format.json { respond_with_bip(@personalcharge) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@personalcharge) }
      end
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
        :travel_allowance, :project_id, :period_id, :person_id, :user_id)
    end
end