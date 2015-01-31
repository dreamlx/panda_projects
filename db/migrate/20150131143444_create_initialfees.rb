class CreateInitialfees < ActiveRecord::Migration
  def change
    create_table :initialfees do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.decimal :service_fee, precision: 10, scale: 2
      t.decimal :commission, precision: 10, scale: 2
      t.decimal :outsourcing, precision: 10, scale: 2
      t.decimal :reimbursement, precision: 10, scale: 2
      t.decimal :meal_allowance, precision: 10, scale: 2
      t.decimal :travel_allowance, precision: 10, scale: 2
      t.decimal :business_tax, precision: 10, scale: 2
      t.decimal :tickets, precision: 10, scale: 2
      t.decimal :courrier, precision: 10, scale: 2
      t.decimal :postage, precision: 10, scale: 2
      t.decimal :stationery, precision: 10, scale: 2
      t.decimal :report_binding, precision: 10, scale: 2
      t.decimal :payment_on_be_half, precision: 10, scale: 2
      t.integer :project_id
      t.decimal :cash_advance, precision: 10, scale: 2
    end
  end
end
