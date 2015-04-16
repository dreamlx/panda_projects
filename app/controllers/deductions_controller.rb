class DeductionsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Deduction.ransack(params[:q])
    @deductions = @q.result.page(params[:page])
  end

  def new
    @deduction = Deduction.new
  end

  def create
    @deduction = Deduction.new(deduction_params)
    if @deduction.save
      redirect_to @deduction, notice: 'Deduction was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @deduction = Deduction.find(params[:id])
  end

  def update
    @deduction = Deduction.find(params[:id])

    respond_to do |format|
      if @deduction.update(deduction_params)
        format.html { redirect_to @deduction, notice: 'Deduction was successfully updated.' }
        format.json { respond_with_bip(@deduction) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@deduction) }
      end
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