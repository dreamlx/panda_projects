class ReportsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Project.search(params[:q])
    if current_user.role == 'hr' ||  current_user.role == 'hr_admin'
      @reports = Report.page(params[:page]).where(state: 'submitted')
    else
      @reports = current_user.reports.page(params[:page])
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      current_user.projects.live.each do |project|
        @report.projects.create!(project_id: project.id)
      end
      redirect_to reports_url
    else
      render 'new'
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

  def json_data
    @report = Report.find(params[:report_id])
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
    start_date  = @report.period.starting_date
    end_date    = @report.period.ending_date
    @total = Array.new
    16.times do |col|
      col_date = start_date + col
      if col_date <= end_date
        @total << Personalcharge.where(charge_date: col_date,project_id: @projects.ids, user_id: @report.user_id ).sum(:hours)  + 
                  Personalcharge.where(charge_date: col_date, project_id: @additional_projects.ids, user_id: @report.user_id ).sum(:hours)
      end
    end
    @overtime = Array.new
    16.times  do |col|
      project_time = Personalcharge.where( charge_date: start_date + col, project_id: @projects.ids, user_id: @report.user_id).sum(:hours)
                     addtional_time = Personalcharge.where( charge_date: start_date + col, project_id: @additional_projects.ids, user_id: @report.user_id ).sum(:hours)
      if weekend(start_date + col.days)
        @overtime << project_time + addtional_time
      else
        @overtime << (((project_time + addtional_time) > 8) ? (project_time + addtional_time -8) : 0)
      end             
    end
    @total_hours = Array.new
    @total_expenses = Array.new
    @projects.each do |project|
      @total_hours << project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:hours)
      @total_expenses << project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:meal_allowance) + 
                      project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id).sum(:travel_allowance)
    end
    (20 - @projects.count).times do |row|
      @total_hours << ""
      @total_expenses << ""
    end
    @additional_projects.each do |project|
      @total_hours << project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:hours)
      @total_expenses << project.personalcharges.where(user_id: @report.user_id, period_id: @report.period_id).sum(:meal_allowance) + 
                project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:travel_allowance)

    end
    @periods = Array.new
    @periods << Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    ).sum(:hours)  + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:hours)
    @periods << Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    ).sum(:meal_allowance) + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:meal_allowance)
    @periods << 0
    @periods << Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    ).sum(:travel_allowance) + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:travel_allowance)
    @periods << Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    ).sum(:meal_allowance) + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:meal_allowance) +
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    ).sum(:travel_allowance) + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:travel_allowance)
    @expenses = Array.new
    @expenses <<  @overtime.inject{|sum,x| sum + x }
  end

  private
    def report_params
      params.require(:report).permit(:period_id)
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