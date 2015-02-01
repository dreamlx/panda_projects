class DeductionsController < ApplicationController
  def index
    id = params[:prj_id]
    item_found =Deduction.find(project_id: id)
    if item_found.nil?
      redirect_to :action => 'new',:id=> id
    else
      redirect_to :action => 'show',:id => item_found
    end    
  end

  def list
    @deduction_pages, @deductions = paginate :deductions, :joins =>"inner join projects on deductions.project_id = projects.id ", :order_by => "projects.job_code"
  end

  def show
    @deduction = Deduction.find(params[:id])
  end

  def new
    init_set
    @deduction = Deduction.new
    @deduction.project_id = params[:id]
  end

  def create
    @deduction = Deduction.new(deduction_params)
    if @deduction.save
      redirect_to :action => 'show', :id => @deduction, notice: 'Deduction was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @deduction = Deduction.find(params[:id])
  end

  def update
    @deduction = Deduction.find(params[:id])
    if @deduction.update(deduction_params)
      redirect_to :action => 'show', :id => @deduction, notice: 'Deduction was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Deduction.find(params[:id]).destroy
    redirect_to deductions_url
  end

  private
    def deduction_params
      params.require(:deduction).permit(
        :created_on, :updated_on, :service_PFA, :service_UFA, :service_billing, :expense_PFA,
        :expense_UFA, :expense_billing, :project_id)
    end
end