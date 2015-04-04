class AddChargeDateToPersonalcharges < ActiveRecord::Migration
  def change
    add_column :personalcharges, :charge_date, :date
    Personalcharge.all.each do |p|
      p.update_column(:charge_date, p.created_on) if p.charge_date.nil?
      p.update(state: "approved")
    end
  end
end
