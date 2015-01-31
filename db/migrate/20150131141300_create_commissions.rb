class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :number
      t.date :date
      t.integer :person_id
      t.decimal :amount, precision: 10, scale: 2
      t.integer :project_id
      t.integer :period_id
    end
  end
end
