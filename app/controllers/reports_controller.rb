class ReportsController < ApplicationController
  def index
    @q = Project.search(params[:q])
    @reports = Report.page(params[:page])
  end

  def new
    @report = Report.new
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to edit_report_path(@report)
    else
      render 'new'
    end
  end

  def edit
    @report = Report.find(params[:id])
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to edit_report_path(@report)
    else
      render 'edit'
    end
  end

  def destroy
    Report.find(params[:id]).destroy
    redirect_to reports_url
  end

  def show
    @report = Report.find(params[:id])
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
  end

  private
    def report_params
      params.require(:report).permit(:user_id, :period_id, projects_attributes: [:id, :name], project_ids: [])
    end
    
    def personalcharge_params
      params.require(:personalcharge).permit(
        :hours, :service_fee, :reimbursement, :meal_allowance, :travel_allowance, 
        :project_id, :period_id, :PFA_of_service_fee, :person_id, :user_id)
    end
end