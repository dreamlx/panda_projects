class OutsourcingsController < ApplicationController
  def index
    id = params[:prj_id]
    item_found =Outsourcing.find(:first,:conditions=>['project_id=?',id])
    if item_found.nil?
      redirect_to 'new', id: id
    else
      @outsourcing_pages, @outsourcings = id ? paginate(:outsourcings, :conditions =>["project_id=?",params[:id]]) : paginate(:outsourcings)
    end     
  end

  def show
    @outsourcing = Outsourcing.find(params[:id])
  end

  def new
    init_set  
    @outsourcing = Outsourcing.new(project_id: params[:id])
  end

  def create
    @outsourcing = Outsourcing.new(params[:outsourcing])
    if @outsourcing.save
      redirect_to outsourcings_url, id: @outsourcing.project_id, notice: 'Outsourcing was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @outsourcing = Outsourcing.find(params[:id])
  end

  def update
    @outsourcing = Outsourcing.find(params[:id])
    if @outsourcing.update(params[:outsourcing])
      redirect_to @outsourcing, notice: 'Outsourcing was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Outsourcing.find(params[:id]).destroy
    redirect_to outsourcings_url, id: params[:prj_id]
  end

  private
    def outsourcing_params
      params.require(:outsourcing).permit(:created_on, :updated_on, :number, :date, :person_id, :amount, :project_id, :period_id)
    end
end
