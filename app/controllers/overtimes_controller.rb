class OvertimesController < ApplicationController
  def index
    init_set
    @ot_types = Dict.where("category = 'ot_type'")
    @overtime = Overtime.new(overtime_params)
    @period   = Period.new(params[:period])
    
    sql_condition =" 1 "
    sql_condition += " and '#{@period.starting_date}' <= ot_date  " unless @period.starting_date.nil?
    sql_condition += " and '#{@period.ending_date}' >= ot_date  " unless @period.ending_date.nil?
    if request.get?
      sql_condition = cookies[:sql] unless overtime_params.nil?
    else
      sql_condition += " and person_id  = #{@overtime.person_id} " unless @overtime.person_id.nil? or @overtime.person_id ==0 
      if @overtime.ot_type_id > 0
        sql_condition += " and ot_type_id = #{@overtime.ot_type_id} " 
      else
        sql_condition += "and ( 0"
        @ot_types.each do |ot_type|
          if @overtime.ot_type_id == 0 and ot_type.code.to_i >0 # ot type+
            sql_condition += " or ot_type_id = #{ot_type.id} " 
          end
          if  @overtime.ot_type_id ==-1 and ot_type.code.to_i <0 #ot type-
            sql_condition += " or ot_type_id = #{ot_type.id} " 
          end 
        end
        sql_condition += " ) "
     end

    end
    @sql          = sql_condition
    cookies[:sql] = sql_condition
    @sum_ot       = Overtime.new(real_hours: Overtime.where(sql_condition).sum("real_hours"), ot_hours: Overtime.where(sql_condition).sum("ot_hours"))
    @overtime_pages, @overtimes = paginate :overtimes, :conditions =>sql_condition
  end

  def show
    @overtime = Overtime.find(params[:id])
  end

  def new
    init_set
    @ot_types = Dict.where("category = 'ot_type'")
    @overtime = Overtime.new
  end

  def create
    @overtime = Overtime.new(overtime_params)
    if count_ot_hour
      redirect_to overtimes_url, notice: 'Overtime was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    init_set
    @ot_types = Dict.where("category = 'ot_type'")
    @overtime = Overtime.find(params[:id])
  end

  def update
    @overtime = Overtime.find(params[:id])
    if @overtime.update(overtime_params)
      count_ot_hour
      redirect_to @overtime, notice: 'Overtime was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Overtime.find(params[:id]).destroy
    redirect_to overtimes_url
  end
  
  private
    def count_ot_hour
      @overtime.ot_hours = @overtime.real_hours * @overtime.ot_type.code.to_i
      @overtime.ot_hours = @overtime.real_hours * (1.5) if @overtime.ot_type.code =='1.5'
      @overtime.save
    end

    def overtime_params
      params.require(:overtime).permit(:created_on, :updated_on, :person_id, :ot_date, :real_hours, :ot_hours, :ot_type_id)
    end
end
