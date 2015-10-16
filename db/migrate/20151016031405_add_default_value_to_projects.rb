class AddDefaultValueToProjects < ActiveRecord::Migration
  def up
    change_column_default(:projects, :contracted_service_fee, 0)
    change_column_default(:projects, :estimated_commision, 0)
    change_column_default(:projects, :estimated_outsorcing, 0)
    change_column_default(:projects, :budgeted_service_fee, 0)
    change_column_default(:projects, :service_PFA, 0)
    change_column_default(:projects, :expense_PFA, 0)
    change_column_default(:projects, :contracted_expense, 0)
    change_column_default(:projects, :budgeted_expense, 0)
  end

  def down
    change_column_default(:projects, :contracted_service_fee, nil)
    change_column_default(:projects, :estimated_commision, nil)
    change_column_default(:projects, :estimated_outsorcing, nil)
    change_column_default(:projects, :budgeted_service_fee, nil)
    change_column_default(:projects, :service_PFA, nil)
    change_column_default(:projects, :expense_PFA, nil)
    change_column_default(:projects, :contracted_expense, nil)
    change_column_default(:projects, :budgeted_expense, nil)
  end
end
