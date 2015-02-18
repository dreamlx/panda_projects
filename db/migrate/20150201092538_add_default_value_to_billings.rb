class AddDefaultValueToBillings < ActiveRecord::Migration
  def up
    change_column_default(:billings, :days_of_ageing, 0)
    change_column_default(:billings, :write_off, 0)
    change_column_default(:billings, :provision, 0)
    change_column_default(:billings, :collection_days, 0)
    change_column_default(:billings, :amount, 0)
    change_column_default(:billings, :outstanding, 0)
    change_column_default(:billings, :service_billing, 0)
    change_column_default(:billings, :expense_billing, 0)
    change_column_default(:billings, :business_tax, 0)
  end

  def down
    change_column_default(:billings, :days_of_ageing, nil)
    change_column_default(:billings, :write_off, nil)
    change_column_default(:billings, :provision, nil)
    change_column_default(:billings, :collection_days, nil)
    change_column_default(:billings, :amount, nil)
    change_column_default(:billings, :outstanding, nil)
    change_column_default(:billings, :service_billing, nil)
    change_column_default(:billings, :expense_billing, nil)
    change_column_default(:billings, :business_tax, nil)
  end
end
