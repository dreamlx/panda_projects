class ReportsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Project.search(params[:q])
    @reports = Report.page(params[:page])
  end

  def new
    @report = Report.new
    @report.user_id = current_user.id if current_user
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to reports_url
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
    report = Report.find(params[:id])
    Personalcharge.where(user_id: report.user_id,  period_id: report.period_id).delete_all
    if report.update(report_params)
      redirect_to reports_url
    else
      render 'edit'
    end
  end

  def destroy
    report = Report.find(params[:id])
    report.destroy
    Personalcharge.where(user_id: report.user_id,  period_id: report.period_id).delete_all
    redirect_to reports_url
  end

  def show
    @report = Report.find(params[:id])
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
    render layout: false
  end

  def add_projects
    @report = Report.find(params[:id])
    if params[:project] && params[:project][:job_code]
      @report.projects << Project.find_by_job_code(params[:project][:job_code])
    end
  end

  def fill_data
    @report = Report.find(params[:id])
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
  end

  def submit
    report = Report.find(params[:id])
    personalcharges = Personalcharge.where(user_id: report.user_id,  period_id: report.period_id)
    personalcharges.each do |personalcharge|
      if filter_personalcharge(personalcharge)
        personalcharge.submit
      end
    end
    report.submit
    redirect_to reports_url
  end

  def approve
    report = Report.find(params[:id])
    personalcharges = Personalcharge.where(user_id: report.user_id,  period_id: report.period_id)
    personalcharges.each do |personalcharge|
      if filter_personalcharge(personalcharge)
        personalcharge.approve
      end
    end
    report.approve
    redirect_to reports_url
  end

    def deny
    report = Report.find(params[:id])
    personalcharges = Personalcharge.where(user_id: report.user_id,  period_id: report.period_id)
    personalcharges.each do |personalcharge|
      if filter_personalcharge(personalcharge)
        personalcharge.deny
      end
    end
    report.deny
    redirect_to reports_url
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

    def filter_personalcharge(personalcharge)
      if (personalcharge.hours == 0) &&  
        (personalcharge.reimbursement == 0) && 
        (personalcharge.meal_allowance == 0) &&
        (personalcharge.travel_allowance == 0) &&
        (personalcharge.state == 'pending')
        personalcharge.delete
        return false
      else
        return true
      end
    end
end