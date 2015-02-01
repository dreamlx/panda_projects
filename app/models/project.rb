class Project < ActiveRecord::Base
  validates   :job_code,    uniqueness: true

  has_one     :deduction
  has_one     :initialfee
  has_many    :outsourcings
  has_many    :commissions
  has_many    :billings
  has_many    :expeases
  has_many    :personalcharges
  has_many    :ufafees
  belongs_to  :client
  belongs_to  :GMU,             class_name: "Dict",   foreign_key: "GMU_id",            -> {where category: 'GMU' }
  belongs_to  :status,          class_name: "Dict",   foreign_key: "status_id",         -> {where category: 'prj_status' }
  belongs_to  :service_code,    class_name: "Dict",   foreign_key: "service_id",        -> {where category: 'service_code' }
  belongs_to  :PFA_reason,      class_name: "Dict",   foreign_key: "PFA_reason_id",     -> {where category: 'PFA_reason' }
  belongs_to  :revenue,         class_name: "Dict",   foreign_key: "revenue_id",        -> {where category: 'revenue_type' }
  belongs_to  :risk,            class_name: "Dict",   foreign_key: "risk_id",           -> {where category: 'risk' }
  belongs_to  :partner,         class_name: "Person", foreign_key: "partner_id"
  belongs_to  :manager,         class_name: "Person", foreign_key: "manager_id"
  belongs_to  :referring,       class_name: "Person", foreign_key: "referring_id"
  belongs_to  :billing_partner, class_name: "Person", foreign_key: "billing_partner_id"  
  belongs_to  :billing_manager, class_name: "Person", foreign_key: "billing_manager_id"   
end
