class InitialfeesController < ApplicationController
  def index
    @q = Initialfee.search(params[:q])
    @initialfees = @q.result.page(params[:page])
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

    respond_to do |format|
      if @initialfee.update(initialfee_params)
        format.html { redirect_to @initialfee, notice: 'Initialfee was successfully updated.' }
        format.json { respond_with_bip(@initialfee) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@initialfee) }
      end
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