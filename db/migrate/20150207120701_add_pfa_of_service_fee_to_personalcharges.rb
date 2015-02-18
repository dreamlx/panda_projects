class AddPfaOfServiceFeeToPersonalcharges < ActiveRecord::Migration
  def up
    add_column :personalcharges, :PFA_of_service_fee, :decimal, precision: 10, scale: 2, default: 0.0

    Personalcharge.all.each do |personalcharge|
      if personalcharge.project && (personalcharge.project.service_PFA != 0)
        personalcharge.update(PFA_of_service_fee: ((personalcharge.service_fee / 100) * personalcharge.project.service_PFA))
      end
    end
  end

  def down
    remove_column :personalcharges, :PFA_of_service_fee
  end
end
