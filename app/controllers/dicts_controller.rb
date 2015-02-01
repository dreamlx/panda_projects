class DictsController < ApplicationController
  def index
    @dict = Dict.new(dict_params)
    if not (@dict.category =="" or @dict.category.nil?)
      condition_sql = " category like '%#{@dict.category}%'"
    else
      condition_sql = " 1 "
    end
    @dict_pages, @dicts = paginate :dicts, :order_by => 'category', :conditions => condition_sql
  end

  def show
    @dict = Dict.find(params[:id])
  end

  def new
    @dict = Dict.new
  end

  def create
    @dict = Dict.new(dict_params)
    if @dict.save
      redirect_to dicts_url, notice: 'Dict was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @dict = Dict.find(params[:id])
  end

  def update
    @dict = Dict.find(params[:id])
    if @dict.update_attributes(dict_params)
      redirect_to @dict, notice: 'Dict was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Dict.find(params[:id]).destroy
    redirect_to dicts_url
  end

  private
    def dict_params
      params.require(:dict).permit(:category, :code, :title)
    end
end