class CreatePrjExpenseLogs < ActiveRecord::Migration
  def change
    create_table :prj_expense_logs do |t|
      t.integer :prj_id
      t.integer :expense_id
      t.integer :period_id
      t.string :other
    end
  end
end
