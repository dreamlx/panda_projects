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
    @personalcharges = Personalcharge.where(period_id: @report.period_id, user_id: @report.user_id)
    @additional_projects = Project.where(job_code: Report.additional_items.values)
    @first_half_month = Array.new
    @second_half_month = Array.new
    @balance_days = 0
    @column_date_array = (@report.period.starting_date.to_date..@report.period.ending_date.to_date).to_a
    if @report.period.starting_date.to_date.day == 1
      @balance_days = 1
      @column_date_array.each do |per_day|
        if weekend(per_day)
          @first_half_month << "[#{per_day.day}]"
        else
          @first_half_month << per_day.day
        end
      end
      
      16.times do
        @second_half_month << "-"
      end
    else
      @balance_days = 31 - @report.period.ending_date.to_date.day
      15.times do
        @first_half_month << "-"
      end
      @column_date_array.each do |per_day|
        if weekend(per_day)
          @second_half_month << "[#{per_day.day}]"
        else
          @second_half_month << per_day.day
        end
      end
      @balance_days.times do
        @second_half_month << "-"
      end
    end
    respond_to do |format|
      format.html { render layout: false}
      format.xml do  
        stream = render_to_string(:template=>"reports/show" )  
        send_data(stream, :type=>"text/xml",:filename => (DateTime.now.to_s(:number) +".xml"))
      end
    end
  end

  def add_projects
    @report = Report.find(params[:id])
    if params[:project] && !params[:project][:job_code].empty?
      @report.projects << Project.find_by_job_code(params[:project][:job_code])
    end
  end

  def delete_project
    @report = Report.find(params[:id])
    project = Project.find(params[:project_id])
    @report.projects.delete(project)
    Personalcharge.where(user_id: @report.user_id,  period_id: @report.period_id, project_id: project.id).delete_all
    redirect_to add_projects_report_path(@report)
  end

  def fill_data
    @report = Report.find(params[:id])
    @projects = @report.projects
    @additional_projects = Project.where(job_code: Report.additional_items.values)
    @personalcharges = Personalcharge.where(period_id: @report.period_id, user_id: @report.user_id)
    @first_half_month = Array.new
    @second_half_month = Array.new
    @balance_days = 0
    @column_date_array = (@report.period.starting_date.to_date..@report.period.ending_date.to_date).to_a
    if @report.period.starting_date.to_date.day == 1
      @balance_days = 1
      @column_date_array.each do |per_day|
        if weekend(per_day)
          @first_half_month << "[#{per_day.day}]"
        else
          @first_half_month << per_day.day
        end
      end
      
      16.times do
        @second_half_month << "-"
      end
    else
      @balance_days = 31 - @report.period.ending_date.to_date.day
      15.times do
        @first_half_month << "-"
      end
      @column_date_array.each do |per_day|
        if weekend(per_day)
          @second_half_month << "[#{per_day.day}]"
        else
          @second_half_month << per_day.day
        end
      end
      @balance_days.times do
        @second_half_month << "-"
      end
    end
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
                      project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id).sum(:travel_allowance)+ 
                      project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id).sum(:reimbursement)
    end
    (20 - @projects.count).times do |row|
      @total_hours << ""
      @total_expenses << ""
    end
    @additional_projects.each do |project|
      @total_hours << project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:hours)
      @total_expenses << project.personalcharges.where(user_id: @report.user_id, period_id: @report.period_id).sum(:meal_allowance) + 
                project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:travel_allowance)+ 
                project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id ).sum(:reimbursement)

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
                    ).sum(:reimbursement) + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:reimbursement)
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
                    ).sum(:travel_allowance)+
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    ).sum(:reimbursement) + 
                  Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    ).sum(:reimbursement)
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