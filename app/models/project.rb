class Project < ActiveRecord::Base
  # validates   :job_code,    uniqueness: true

  has_one     :deduction
  has_one     :initialfee
  has_many    :outsourcings
  has_many    :commissions
  has_many    :billings
  has_many    :expenses
  has_many    :personalcharges
  has_many    :ufafees
  has_many    :bookings,        :dependent => :destroy
  has_many    :users,           through: :bookings
  has_and_belongs_to_many       :reports
  belongs_to  :client
  belongs_to  :GMU,             -> {where category: 'GMU' },          class_name: "Dict", foreign_key: "GMU_id"      
  belongs_to  :status,          -> {where category: 'prj_status' },   class_name: "Dict", foreign_key: "status_id"
  belongs_to  :service_code,    -> {where category: 'service_code' }, class_name: "Dict", foreign_key: "service_id"
  belongs_to  :PFA_reason,      -> {where category: 'PFA_reason' },   class_name: "Dict", foreign_key: "PFA_reason_id"
  belongs_to  :revenue,         -> {where category: 'revenue_type' }, class_name: "Dict", foreign_key: "revenue_id"
  belongs_to  :risk,            -> {where category: 'risk' },         class_name: "Dict", foreign_key: "risk_id"
  belongs_to  :service,         -> {where category:'service'},        class_name: "Dict", foreign_key: "service_id"
  belongs_to  :partner,                                               class_name: "User", foreign_key: "partner_id"
  belongs_to  :manager,                                               class_name: "User", foreign_key: "manager_id"
  belongs_to  :referring,                                             class_name: "User", foreign_key: "referring_id"
  belongs_to  :billing_partner,                                       class_name: "User", foreign_key: "billing_partner_id"  
  belongs_to  :billing_manager,                                       class_name: "User", foreign_key: "billing_manager_id"

  after_save do
    Booking.find_or_create_by(project_id: self.id, user_id: self.partner_id) if self.partner_id
    Booking.find_or_create_by(project_id: self.id, user_id: self.manager_id) if self.manager_id
    Booking.find_or_create_by(project_id: self.id, user_id: self.referring_id) if self.referring_id
    Booking.find_or_create_by(project_id: self.id, user_id: self.billing_partner_id) if self.billing_partner_id
    Booking.find_or_create_by(project_id: self.id, user_id: self.billing_manager_id) if self.billing_manager_id
  end
  scope :num_projects,  ->  {where("job_code REGEXP '^[0-9]'")}
  scope :char_projects, ->  {where("job_code REGEXP '^[a-z]'")}
  def self.live
    live_projects = Array.new
    all.order(job_code: :asc).each do |project|
      live_projects << project if project.status.title != 'closed'
    end
    return live_projects
  end
  def name
    job_code
  end

  def name_with_initial
    "#{id}||#{job_code}"
  end
end
