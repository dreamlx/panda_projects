class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.decimal :commission, precision: 10, scale: 2
      t.decimal :outsourcing, precision: 10, scale: 2
      t.decimal :tickets, precision: 10, scale: 2
      t.decimal :courrier, precision: 10, scale: 2
      t.decimal :postage, precision: 10, scale: 2
      t.decimal :stationery, precision: 10, scale: 2
      t.decimal :report_binding, precision: 10, scale: 2
      t.decimal :cash_advance, precision: 10, scale: 2
      t.integer :period_id
      t.integer :project_id
      t.decimal :payment_on_be_half, precision: 10, scale: 2
      t.string :memo
    end
  end
end
