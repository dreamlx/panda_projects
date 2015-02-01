class InitialfeesController < ApplicationController
  def index
    id = params[:prj_id]
    item_found=Initialfee.find(project_id: id)
    if item_found.nil?     
      redirect_to :action => 'new', :id =>id
    else
      redirect_to :action => 'show', :id =>item_found
    end
  end

  def list
    @initialfee_pages, @initialfees = paginate  :initialfees, :joins =>"inner join projects on initialfees.project_id = projects.id ", :order_by => "projects.job_code"                                 
  end

  def show
    @initialfee = Initialfee.find(params[:id])
  end

  def new
    init_set 
    @initialfee = Initialfee.new(project_id: params[:id])
  end

  def create
    @initialfee = Initialfee.new(initialfee_params)
    if @initialfee.save
      redirect_to @initialfee, notice: 'Initialfee was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @initialfee = Initialfee.find(params[:id])
  end

  def update
    @initialfee = Initialfee.find(params[:id])
    if @initialfee.update(initialfee_params)
      redirect_to @initialfee, notice: 'Initialfee was successfully updated.'
    else
      render :action => 'edit'
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