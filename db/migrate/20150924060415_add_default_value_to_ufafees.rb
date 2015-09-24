class AddDefaultValueToUfafees < ActiveRecord::Migration
  def up
    change_column_default(:ufafees, :service_UFA, 0)
    change_column_default(:ufafees, :expense_UFA, 0)
  end

  def down
    change_column_default(:ufafees, :service_UFA, nil)
    change_column_default(:ufafees, :expense_UFA, nil)
  end
end
