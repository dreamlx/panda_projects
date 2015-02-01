class IndustriesController < ApplicationController
  def index
    @industry_pages, @industries = paginate :industries
  end

  def show
    @industry = Industry.find(params[:id])
  end

  def new
    @industry = Industry.new
  end

  def create
    @industry = Industry.new(params[:industry])
    if @industry.save
      redirect_to industries_url, notice: 'Industry was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @industry = Industry.find(params[:id])
  end

  def update
    @industry = Industry.find(params[:id])
    if @industry.update(params[:industry])
      redirect_to @industry, notice: 'Industry was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Industry.find(params[:id]).destroy
    redirect_to industries_url
  end

  private
    def industry_params
      params.require(:industry).permit(:code, :title)
    end
end
