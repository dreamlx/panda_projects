namespace :booking do
  task :create => :environment do
    Project.all.each do |project|
      Booking.find_or_create_by(project_id: project.id, user_id: project.partner_id) if project.partner_id
      Booking.find_or_create_by(project_id: project.id, user_id: project.manager_id) if project.manager_id
      Booking.find_or_create_by(project_id: project.id, user_id: project.referring_id) if project.referring_id
    end
  end
end