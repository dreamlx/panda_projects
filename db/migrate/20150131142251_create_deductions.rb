class CreateDeductions < ActiveRecord::Migration
  def change
    create_table :deductions do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.decimal :service_PFA, precision: 10, scale: 2
      t.decimal :service_UFA, precision: 10, scale: 2
      t.decimal :service_billing, precision: 10, scale: 2
      t.decimal :expense_PFA, precision: 10, scale: 2
      t.decimal :expense_UFA, precision: 10, scale: 2
      t.decimal :expense_billing, precision: 10, scale: 2
      t.integer :project_id

    end
  end
end
