class AddDefaultValueToDeductions < ActiveRecord::Migration
  def up
    change_column_default(:deductions, :service_PFA, 0)
    change_column_default(:deductions, :service_UFA, 0)
    change_column_default(:deductions, :service_billing, 0)
    change_column_default(:deductions, :expense_PFA, 0)
    change_column_default(:deductions, :expense_UFA, 0)
    change_column_default(:deductions, :expense_billing, 0)
  end

  def down
    change_column_default(:deductions, :service_PFA, nil)
    change_column_default(:deductions, :service_UFA, nil)
    change_column_default(:deductions, :service_billing, nil)
    change_column_default(:deductions, :expense_PFA, nil)
    change_column_default(:deductions, :expense_UFA, nil)
    change_column_default(:deductions, :expense_billing, nil)
  end
end
