class AddIndexToPersonalcharges < ActiveRecord::Migration
  def change
    add_index :personalcharges, :service_fee
    add_index :personalcharges, :reimbursement
    add_index :personalcharges, :meal_allowance
    add_index :personalcharges, :travel_allowance
    add_index :personalcharges, :period_id
    add_index :expenses, :commission
    add_index :expenses, :outsourcing
    add_index :expenses, :tickets
    add_index :expenses, :courrier
    add_index :expenses, :stationery
    add_index :expenses, :postage
    add_index :expenses, :report_binding
    add_index :expenses, :payment_on_be_half
    add_index :expenses, :period_id
    add_index :billings, :service_billing
    add_index :billings, :expense_billing
    add_index :billings, :business_tax
    add_index :billings, :period_id
  end
end
