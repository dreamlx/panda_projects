class CreateToupiaos < ActiveRecord::Migration
  def change
    create_table :toupiaos do |t|
      t.string :name
      t.string :email
      t.string :other
      t.boolean :picked
      t.string :other2
      t.string :other3
      t.string :other4
    end
  end
end
