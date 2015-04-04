class AddPfaOfServiceFeeToPersonalcharges < ActiveRecord::Migration
  def up
    add_column :personalcharges, :PFA_of_service_fee, :decimal, precision: 10, scale: 2, default: 0.0
  end

  def down
    remove_column :personalcharges, :PFA_of_service_fee, :decimal
  end
end
