class DictsController < ApplicationController
  def index
    @q = Dict.search(params[:q])
    @dicts = @q.result
  end

  def new
    @dict= Dict.new
  end

  def create
    @dict = Dict.new(dict_params)
    if @dict.save      
      redirect_to dicts_path, notice: 'dict was successfully created.'
    else
      render "new"
    end
  end

  def update
    @dict = Dict.find(params[:id])

    respond_to do |format|
      if @dict.update(dict_params)
        format.html { redirect_to @dict, notice: 'Dict was successfully updated.' }
        format.json { respond_with_bip(@dict) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@dict) }
      end
    end
  end

  def destroy
    Dict.find(params[:id]).destroy
    redirect_to dicts_path
  end

  private
    def dict_params
      params.require(:dict).permit(:category, :code, :title)
    end
end