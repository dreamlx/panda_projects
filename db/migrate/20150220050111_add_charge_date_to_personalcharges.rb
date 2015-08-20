class AddChargeDateToPersonalcharges < ActiveRecord::Migration
  def up
    add_column :personalcharges, :charge_date, :date
    Personalcharge.all.each do |p|
      p.update_column(:charge_date, p.created_on) if p.charge_date.nil?
    end
    Personalcharge.update_all(state: "approved")
  end

  def down
    remove_column :personalcharges, :charge_date
    Personalcharge.update_all(state: "pending")
  end
end
