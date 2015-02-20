class AddChargeDateToPersonalcharges < ActiveRecord::Migration
  def change
    add_column :personalcharges, :charge_date, :date
  end
end
