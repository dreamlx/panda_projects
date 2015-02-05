class IndustriesController < ApplicationController
  def index
    @q = Industry.search(params[:q])
    @industries  = @q.result.order(:code)
  end

  def new
    @industry = Industry.new
  end

  def create
    @industry = Industry.new(industry_params)
    if @industry.save
      redirect_to industries_path, notice: 'Industry was successfully created.'
    else
      render 'new'
    end
  end

  def update
    @industry = Industry.find(params[:id])
    respond_to do |format|
      if @industry.update(industry_params)
        format.html {redirect_to @industry, notice: 'Industry was successfully updated.'}
        format.json { respond_with_bip(@industry)}
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@industry) }
      end
    end
    
  end

  def destroy
    Industry.find(params[:id]).destroy
    redirect_to industries_path
  end

  private
    def industry_params
      params.require(:industry).permit(:code, :title)
    end
end
