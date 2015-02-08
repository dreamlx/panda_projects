class AddDefaultValuesToExpenses < ActiveRecord::Migration
  def up
    change_column_default(:expenses, :commission, 0)
    change_column_default(:expenses, :outsourcing, 0)
    change_column_default(:expenses, :tickets, 0)
    change_column_default(:expenses, :courrier, 0)
    change_column_default(:expenses, :postage, 0)
    change_column_default(:expenses, :stationery, 0)
    change_column_default(:expenses, :report_binding, 0)
    change_column_default(:expenses, :cash_advance, 0)
    change_column_default(:expenses, :payment_on_be_half, 0)
  end

  def down
    change_column_default(:expenses, :commission, nil)
    change_column_default(:expenses, :outsourcing, nil)
    change_column_default(:expenses, :tickets, nil)
    change_column_default(:expenses, :courrier, nil)
    change_column_default(:expenses, :postage, nil)
    change_column_default(:expenses, :stationery, nil)
    change_column_default(:expenses, :report_binding, nil)
    change_column_default(:expenses, :cash_advance, nil)
    change_column_default(:expenses, :payment_on_be_half, nil)
  end
end
