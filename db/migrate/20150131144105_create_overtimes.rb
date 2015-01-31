class CreateOvertimes < ActiveRecord::Migration
  def change
    create_table :overtimes do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.integer :person_id
      t.date :ot_date
      t.decimal :real_hours, precision: 10, scale: 2
      t.decimal :ot_hours, precision: 10, scale: 2
      t.integer :ot_type_id
    end
  end
end
