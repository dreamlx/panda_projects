class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :item_id
      t.integer :project_id
      t.integer :department_id
      t.integer :cost_status_id
      t.string :description
      t.timestamp :created_on
      t.timestamp :updated_on
    end
  end
end
