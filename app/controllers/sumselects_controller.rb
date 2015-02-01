class SumselectsController < ApplicationController
  def index
    @sumselect_pages, @sumselects = paginate :sumselects
  end

  def show
    @sumselect = Sumselect.find(params[:id])
  end

  def new
    @sumselect = Sumselect.new
  end

  def create
    @sumselect = Sumselect.new(sumselect_params)
    if @sumselect.save
      redirect_to sumselects_url, notice: 'Sumselect was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @sumselect = Sumselect.find(params[:id])
  end

  def update
    @sumselect = Sumselect.find(params[:id])
    if @sumselect.update(sumselect_params)
      redirect_to @sumselect, notice: 'Sumselect was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Sumselect.find(params[:id]).destroy
    redirect_to sumselects_url
  end

  private
    def sumselect_params
      params.permit(:sumselect).permit(:type, :count_item)
    end
end
