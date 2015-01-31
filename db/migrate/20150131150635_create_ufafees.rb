class CreateUfafees < ActiveRecord::Migration
  def change
    create_table :ufafees do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :number
      t.decimal :amount, precision: 10, scale: 2
      t.integer :project_id
      t.integer :period_id
      t.decimal :service_UFA, precision: 10, scale: 2
      t.decimal :expense_UFA, precision: 10, scale: 2
    end
  end
end
