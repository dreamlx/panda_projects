class FillChargeDateOfPersonalcharges < ActiveRecord::Migration
  def up
    Personalcharge.all.each do |p|
      p.update(charge_date: p.created_on) if p.charge_date.nil?
    end
  end

  def down
  end
end