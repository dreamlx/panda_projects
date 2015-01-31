class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :contract_number
      t.integer :client_id
      t.integer :GMU_id
      t.integer :service_id
      t.string :job_code
      t.string :description
      t.date :starting_date
      t.date :ending_date
      t.decimal :estimated_annual_fee, precision: 10, scale: 2
      t.integer :risk_id
      t.integer :status_id
      t.integer :partner_id
      t.integer :manager_id
      t.integer :referring_id
      t.integer :billing_partner_id
      t.integer :billing_manager_id
      t.decimal :contracted_service_fee, precision: 10, scale: 2
      t.decimal :estimated_commision, precision: 10, scale: 2
      t.decimal :estimated_outsorcing, precision: 10, scale: 2
      t.decimal :budgeted_service_fee, precision: 10, scale: 2
      t.integer :service_PFA
      t.integer :expense_PFA
      t.decimal :contracted_expense, precision: 10, scale: 2
      t.decimal :budgeted_expense, precision: 10, scale: 2
      t.integer :PFA_reason_id
      t.integer :revenue_id
    end
  end
end
