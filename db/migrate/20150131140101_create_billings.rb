class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :number
      t.date :billing_date
      t.integer :person_id
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :outstanding, precision: 10, scale: 2
      t.decimal :service_billing, precision: 10, scale: 2
      t.decimal :expense_billing, precision: 10, scale: 2
      t.integer :days_of_ageing
      t.decimal :business_tax, precision: 10, scale: 2
      t.string :status
      t.integer :collection_days
      t.integer :project_id
      t.integer :period_id
      t.decimal :write_off
      t.decimal :provision
    end
  end
end
