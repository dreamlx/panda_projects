class CommissionsController < ApplicationController
  def index
    id = params[:prj_id]
    item_found =Commission.find(project_id: id)
    if item_found.nil?
      redirect_to :action => 'new',:id=> id
    else
      redirect_to :action => 'list',:id => id
    end 
  end

  def list
    if params[:id].nil?
      @commission_pages, @commissions = paginate :commissions
    else
      @commission_pages, @commissions = paginate :commissions, :conditions =>["project_id=?",params[:id]]
    end
  end

  def show
    @commission = Commission.find(params[:id])
  end

  def new
    init_set
    @commission = Commission.new
    @commission.project_id = params[:id]    
  end

  def create
    @commission = Commission.new(params[:commission])
    if @commission.save
      flash[:notice] = 'Commission was successfully created.'
      redirect_to :action => 'list',  :id=> @commission.project_id
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @commission = Commission.find(params[:id])
  end

  def update
    @commission = Commission.find(params[:id])
    if @commission.update(params[:commission])
      redirect_to :action => 'show', :id => @commission, notice: 'Commission was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Commission.find(params[:id]).destroy
    redirect_to :action => 'list', :id => params[:prj_id]
  end

  private
    def commission_params
      params.require(:commission).permit(
        :created_on, :updated_on, :number, :date, :person_id, :amount, :project_id, :period_id)
    end
end
