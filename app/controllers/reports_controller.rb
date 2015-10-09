class ReportsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Report.search(params[:q])
    if current_user.role == 'hr' ||  current_user.role == 'hr_admin'
      @reports = @q.result.where(state: 'submitted').page(params[:page])
    else
      @reports = @q.result.where(user_id: current_user.id).page(params[:page])
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
    projects = Project.close.includes(:personalcharges).where(personalcharges: {id: personalcharges.ids}).uniq
    notice = "#{projects.pluck(:job_code)*","} closed"
    personalcharges.each do |personalcharge|
      if filter_personalcharge(personalcharge)
        if personalcharge.project.status_id == 252 # the project closed
          personalcharge.delete
        else
          personalcharge.submit
        end
      end
    end
    report.submit
    if notice.length < 10
      redirect_to reports_url
    else
      redirect_to reports_url, notice: notice
    end
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
    personalcharges = Personalcharge.where(period_id: @report.period_id, user_id: @report.user_id)
    start_date  = @report.period.starting_date
    end_date    = @report.period.ending_date
    @total = Array.new
    @total << remove_zero(Personalcharge.where(charge_date: nil,period_id: @report.period_id, user_id: @report.user_id ).sum(:hours))
    16.times do |col|
      col_date = start_date + col
      if col_date <= end_date
        pc_hours = Personalcharge.where(charge_date: col_date,project_id: @projects.ids, user_id: @report.user_id, period_id: @report.period_id ).sum(:hours)  + 
                  Personalcharge.where(charge_date: col_date, project_id: @additional_projects.ids, user_id: @report.user_id, period_id: @report.period_id ).sum(:hours)
        @total << remove_zero(pc_hours)
      end
    end
    @overtime = Array.new
    @overtime << remove_zero(Personalcharge.where(charge_date: nil,period_id: @report.period_id, user_id: @report.user_id ).sum(:hours))
    16.times  do |col|
      project_time = Personalcharge.where( charge_date: start_date + col, project_id: @projects.ids, user_id: @report.user_id, period_id: @report.period_id).sum(:hours)
      addtional_time = Personalcharge.where( charge_date: start_date + col, project_id: @additional_projects.ids, user_id: @report.user_id, period_id: @report.period_id ).sum(:hours)
      if weekend(start_date + col.days)
        pc_overtime = project_time + addtional_time
        @overtime << remove_zero(pc_overtime)
      else
        @overtime << (((project_time + addtional_time) > 8) ? (project_time + addtional_time -8) : "")
      end             
    end
    @total_hours = Array.new
    @total_expenses = Array.new
    @projects.each do |project|
      project_pcs = project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id )
      @total_hours << remove_zero(project_pcs.sum(:hours))
      @total_expenses << keep_dash(project_pcs.sum(:meal_allowance) + 
                      project_pcs.sum(:travel_allowance)+ 
                      project_pcs.sum(:reimbursement))
    end
    (19 - @projects.count).times do |row|
      @total_hours << ""
      @total_expenses << "-"
    end
    @additional_projects.each do |project|
      additional_project_pcs = project.personalcharges.where( user_id: @report.user_id, period_id: @report.period_id )
      @total_hours << remove_zero(additional_project_pcs.sum(:hours))
      @total_expenses << keep_dash(additional_project_pcs.sum(:meal_allowance) + 
                additional_project_pcs.sum(:travel_allowance)+ 
                additional_project_pcs.sum(:reimbursement))

    end
    @periods = Array.new
    pcs = Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.ids,
                    user_id: @report.user_id
                    )
    add_pcs = Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @additional_projects.ids,
                    user_id: @report.user_id
                    )
    @periods << remove_zero(pcs.sum(:hours) + add_pcs.sum(:hours))
    @periods << keep_dash(pcs.sum(:meal_allowance) + add_pcs.sum(:meal_allowance))
    @periods << keep_dash(pcs.sum(:travel_allowance) + add_pcs.sum(:travel_allowance))
    @periods << keep_dash(pcs.sum(:reimbursement) + add_pcs.sum(:reimbursement))
    @periods << keep_dash(pcs.sum(:meal_allowance) + add_pcs.sum(:meal_allowance) + pcs.sum(:travel_allowance) + add_pcs.sum(:travel_allowance) + pcs.sum(:reimbursement) + add_pcs.sum(:reimbursement))
    char_pcs = Personalcharge.where(
                    period_id: @report.period_id, 
                    project_id: @projects.char_projects.ids,
                    user_id: @report.user_id
                    )
    @periods << remove_zero(char_pcs.sum(:hours))
    @expenses = Array.new
    new_overtime = @overtime.reject(&:blank?)
    @expenses <<  new_overtime.inject{|sum,x| sum + x }
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