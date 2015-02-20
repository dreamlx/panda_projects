class BookingsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @booking = @project.bookings.build(booking_params)
    if @booking.save
      redirect_to(@project, :notice => 'Booking was successfully created.')
    else
      redirect_to(@project, :notice => 'employee already exist, please destroy record first.')
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @project.bookings.find(params[:id]).destroy
    redirect_to @project, notice: "Success"
  end

  private
    def booking_params
      params.require(:booking).permit(:user_id, :hours, :project_id)
    end
end