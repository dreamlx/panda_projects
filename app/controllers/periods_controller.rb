class PeriodsController < ApplicationController
  def index
    @periods = Period.order(:number).page(params[:page])
  end

  def show
    @period = Period.find(params[:id])
  end

  def new
    @period = Period.new
  end

  def edit
    @period = Period.find(params[:id])
  end

  def create
    @period = Period.new(period_params)
    if @period.save
      redirect_to @period, notice: _('%s was successfully created.', Period.human_name)
    else
      render "new"
    end
  end

  def update
    @period = Period.find(params[:id])
    if @period.update(period_params)
      redirect_to @period, notice: _('%s was successfully updated.', Period.human_name)
    else
      render "edit"
    end
  end

  def destroy
    Period.find(params[:id]).destroy
    redirect_to periods_url
  end

  private
    def period_params
      params.require(:period).permit(:number, :starting_date, :ending_date, :created_on)
    end
end