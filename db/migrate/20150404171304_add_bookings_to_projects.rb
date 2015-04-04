class AddBookingsToProjects < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      Booking.find_or_create_by(project_id: project.id, user_id: project.partner_id) if project.partner_id
      Booking.find_or_create_by(project_id: project.id, user_id: project.manager_id) if project.manager_id
      Booking.find_or_create_by(project_id: project.id, user_id: project.referring_id) if project.referring_id
      Booking.find_or_create_by(project_id: project.id, user_id: project.billing_partner_id) if project.billing_partner_id
      Booking.find_or_create_by(project_id: project.id, user_id: project.billing_manager_id) if project.billing_manager_id
    end
  end

  def down
    Booking.delete_all
  end
end
