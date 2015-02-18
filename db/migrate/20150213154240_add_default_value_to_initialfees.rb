class AddDefaultValueToInitialfees < ActiveRecord::Migration
  def up
    change_column_default(:initialfees, :service_fee, 0)
    change_column_default(:initialfees, :commission, 0)
    change_column_default(:initialfees, :outsourcing, 0)
    change_column_default(:initialfees, :reimbursement, 0)
    change_column_default(:initialfees, :meal_allowance, 0)
    change_column_default(:initialfees, :travel_allowance, 0)
    change_column_default(:initialfees, :business_tax, 0)
    change_column_default(:initialfees, :tickets, 0)
    change_column_default(:initialfees, :courrier, 0)
    change_column_default(:initialfees, :postage, 0)
    change_column_default(:initialfees, :stationery, 0)
    change_column_default(:initialfees, :report_binding, 0)
    change_column_default(:initialfees, :payment_on_be_half, 0)
    change_column_default(:initialfees, :cash_advance, 0)
    change_column_default(:receive_amounts, :receive_amount, 0)
  end

  def down
    change_column_default(:initialfees, :service_fee, nil)
    change_column_default(:initialfees, :commission, nil)
    change_column_default(:initialfees, :outsourcing, nil)
    change_column_default(:initialfees, :reimbursement, nil)
    change_column_default(:initialfees, :meal_allowance, nil)
    change_column_default(:initialfees, :travel_allowance, nil)
    change_column_default(:initialfees, :business_tax, nil)
    change_column_default(:initialfees, :tickets, nil)
    change_column_default(:initialfees, :courrier, nil)
    change_column_default(:initialfees, :postage, nil)
    change_column_default(:initialfees, :stationery, nil)
    change_column_default(:initialfees, :report_binding, nil)
    change_column_default(:initialfees, :payment_on_be_half, nil)
    change_column_default(:initialfees, :cash_advance, nil)
    change_column_default(:receive_amounts, :receive_amount, nil)
  end
end
