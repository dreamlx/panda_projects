class PersonalchargesController < ApplicationController
  def index
    prj_id = params[:prj_id]
    person_id = params[:person_id]
    
    if params[:person_id]
      redirect_to :action => 'list', :person_id => person_id
    else
      item_found =Personalcharge.find(project_id: prj_id)
      if item_found.nil?
        redirect_to 'new',:id=> prj_id
      else
        redirect_to 'prj_list',:id => prj_id
      end 
    end 
  end

  def list
    get_now_period
    if not params[:person_id].nil?
      if not @now_period.nil?
        @personalcharge_pages, @personalcharges = paginate( :personalcharges, :conditions =>["person_id=? and period_id =?",params[:person_id],@now_period.id], :order_by =>'period_id')
      else
        @personalcharge_pages, @personalcharges = paginate( :personalcharges, :conditions =>["person_id=? ",params[:person_id]],   :order_by =>'period_id')
      end
    else
      if params[:id].nil?
        @personalcharge_pages, @personalcharges = paginate( :personalcharges,  :order_by => 'project_id')  
      else
        @personalcharge_pages, @personalcharges = paginate( :personalcharges, :conditions =>["project_id=?",params[:id]])
      end
    end
  end
  
  def prj_list
    if params[:id].nil?
      @personalcharge_pages, @personalcharges = paginate( :personalcharges,  :order_by => 'project_id')  
    else
      @personalcharge_pages, @personalcharges = paginate( :personalcharges, :conditions =>["project_id=?",params[:id]])
    end  
  end

  def show
    @personalcharge = Personalcharge.find(params[:id])
  end
  
  def prj_show
    @personalcharge = Personalcharge.find(params[:id])
  end

  def new
    init_set
    @personalcharge = Personalcharge.new
    if not params[:person_id].nil?
      @personalcharge.person_id = params[:person_id]
    else  
      if not params[:id].nil?
        @personalcharge.project_id = params[:id]
      end
    end
  end

  def create
    @personalcharge = Personalcharge.new(personalcharge_params)
    person = Person.find(@personalcharge.person_id)
    @personalcharge.service_fee = @personalcharge.hours * person.charge_rate
    if @personalcharge.save
      flash[:notice] = 'Personalcharge was successfully created.'
      redirect_to :action => 'list', :person_id => @personalcharge.person_id, :id => @personalcharge.project_id
    else
      render 'new'
    end
  end

  def edit
    init_set
    @personalcharge = Personalcharge.find(params[:id])
  end

  def update
    @personalcharge = Personalcharge.find(params[:id])
    if @personalcharge.update(personalcharge_params)
      @personalcharge.update(service_fee: @personalcharge.hours * @personalchargeperson.charge_rate ) if @personalcharge.person.charge_rate
      redirect_to @personalcharge, notice: 'Personalcharge was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Personalcharge.find(params[:id]).destroy
    redirect_to 'list', person_id: params[:person_id], id: params[:prj_id]
  end
  
  def search
    @personalcharge = Personalcharge.new(personalcharge_params)
    @personalcharge.period_id = nil
    period_from_id = params[:period_from]
    period_to_id = params[:period_to]
    @period_condition = " "
    if period_from_id == period_to_id
      @personalcharge.period_id = period_to_id
    else  
      unless period_from_id == ""
        @start_period = Period.find(period_from_id)
        @period_condition += " and C.starting_date >= '#{@start_period.starting_date}' "  
      end
      
      unless period_to_id == ""
        @end_period = Period.find(period_to_id)
        @period_condition += " and C.ending_date <= '#{@end_period.ending_date}' "
      end
    end
    @p_total = Personalcharge.new
    @projects = Project.find(:all, :order => 'job_code')
    @periods = Period.find(:all, :order =>'number DESC')
    @people =Person.find(:all,:order=>"english_name",:include=>:status,:conditions=>"title = 'Employed'")
    
    sql_condition = " 1 "
    
    if not @personalcharge.period_id.nil?       
      sql_condition += " and period_id = #{ @personalcharge.period_id} "
    else
      sql_condition = " 1 " + @period_condition
    end
    
    if not @personalcharge.person_id .nil?
      sql_condition += " and person_id = #{ @personalcharge.person_id} "
    end
    
    if not @personalcharge.project_id.nil? and not ( @personalcharge.project_id == -1 or  @personalcharge.project_id == -2 )
      sql_condition += " and project_id =#{ @personalcharge.project_id} "
    end
    
    # select the frist char of jobCode in 0-9  
    if @personalcharge.project_id == -1
      sql_condition += " AND left( job_code, 1 )IN ( 01, 2, 3, 4, 5, 6, 7, 8, 9 )  "
    end
    
    # select the frist char of jobCode not in 0-9 
    if @personalcharge.project_id == -2
      sql_condition += " AND left( job_code, 1 )NOT IN ( 01, 2, 3, 4, 5, 6, 7, 8, 9 )"
    end
      
    sql_str ="select D.job_code, C.number, B.english_name, A.* from "+              "personalcharges as A, people as B,periods as C, projects as D "+              " where A.person_id = B.id and A.period_id = C.id and A.project_id = D.id and "
    sql_order =" order by D.job_code,  C.number, B.english_name "       
    @personalcharges        = Personalcharge.find_by_sql(sql_str + sql_condition + sql_order)
    @tempsql =sql_str + sql_condition + sql_order
    join_sql = " inner join projects on personalcharges.project_id = projects.id left join periods as C on personalcharges.period_id = C.id "
    @p_total.hours          = Personalcharge.sum("hours",         :joins =>join_sql,        :conditions =>sql_condition)
    @p_total.service_fee    = Personalcharge.sum("service_fee",         :joins =>join_sql,        :conditions =>sql_condition)                      
    @p_total.reimbursement  = Personalcharge.sum("reimbursement",         :joins =>join_sql,        :conditions =>sql_condition)
    @p_total.meal_allowance = Personalcharge.sum("meal_allowance",         :joins =>join_sql,        :conditions =>sql_condition)
    @p_total.travel_allowance = Personalcharge.sum("travel_allowance",         :joins =>join_sql,        :conditions =>sql_condition)
    @p_count = Personalcharge.count(          :joins =>join_sql,          :conditions =>sql_condition)
    @pfa_fee = [0,0]
    @p_t1 = Personalcharge.new
    @p_t0 = Personalcharge.new
  end

  def get_now_period
    @cookie_value = cookies[:the_time]
    sql_condition = @cookie_value != "" ? " id = '#{@cookie_value}'" : "id = 0"
    @now_period = Period.where(sql_condition).first
  end

  private
    def personalcharge_params
      params.require(:personalcharge).permit(
        :created_on, :updated_on, :hours, :service_fee, :reimbursement, :meal_allowance,
        :travel_allowance, :project_id, :period_id, :person_id)
    end
end