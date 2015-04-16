class ItemsController < ApplicationController
  load_and_authorize_resource
  def index
    @items = Item.page(params[:page])
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_url, notice: 'Item was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    redirect_to items_url
  end

  private
    def item_params
      params.require(:item).permit(:code, :titlename, :img_url)
    end
end