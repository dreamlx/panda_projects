class PeriodsController < ApplicationController
  # load_and_authorize_resource
  def index
    @q = Period.search(params[:q])
    @periods = @q.result.order(id: :desc)
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
      redirect_to periods_url
    else
      render "new"
    end
  end

  def update
    @period = Period.find(params[:id])
    if @period.update(period_params)
      redirect_to periods_url
    else
      render "edit"
    end
  end

  private
    def period_params
      params.require(:period).permit(:number, :starting_date, :ending_date, :created_on)
    end
end