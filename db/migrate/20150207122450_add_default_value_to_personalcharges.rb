class AddDefaultValueToPersonalcharges < ActiveRecord::Migration
  def up
    change_column_default(:personalcharges, :hours, 0)
    change_column_default(:personalcharges, :service_fee, 0)
    change_column_default(:personalcharges, :reimbursement, 0)
    change_column_default(:personalcharges, :meal_allowance, 0)
    change_column_default(:personalcharges, :travel_allowance, 0)
  end

  def down
    change_column_default(:personalcharges, :hours, nil)
    change_column_default(:personalcharges, :service_fee, nil)
    change_column_default(:personalcharges, :reimbursement, nil)
    change_column_default(:personalcharges, :meal_allowance, nil)
    change_column_default(:personalcharges, :travel_allowance, nil)
  end
end
