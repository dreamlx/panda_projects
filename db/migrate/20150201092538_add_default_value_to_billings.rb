class AddDefaultValueToBillings < ActiveRecord::Migration
  def up
    change_column_default(:billings, :days_of_ageing, 0)
    change_column_default(:billings, :write_off, 0)
    change_column_default(:billings, :provision, 0)
    change_column_default(:billings, :collection_days, 0)
  end

  def down
    change_column_default(:billings, :days_of_ageing, nil)
    change_column_default(:billings, :write_off, nil)
    change_column_default(:billings, :provision, nil)
    change_column_default(:billings, :collection_days, nil)
  end
end
