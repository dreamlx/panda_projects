class AddStateToPersonalcharges < ActiveRecord::Migration
  def up
    add_column :personalcharges, :state, :string
    Personalcharge.update_all(state: "approved")
  end
  def down
    remove_column :personalcharges, :state, :string
  end
end
