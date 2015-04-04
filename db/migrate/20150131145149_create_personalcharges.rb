class CreatePersonalcharges < ActiveRecord::Migration
  def change
    create_table :personalcharges do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.decimal :hours, precision: 10, scale: 2
      t.decimal :service_fee, precision: 10, scale: 2
      t.decimal :reimbursement, precision: 10, scale: 2
      t.decimal :meal_allowance, precision: 10, scale: 2
      t.decimal :travel_allowance, precision: 10, scale: 2
      t.integer :project_id
      t.integer :period_id
      t.integer :person_id
      t.string  :state
    end
  end
end
