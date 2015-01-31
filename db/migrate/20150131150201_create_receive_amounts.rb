class CreateReceiveAmounts < ActiveRecord::Migration
  def change
    create_table :receive_amounts do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.integer :billing_id
      t.string :invoice_no
      t.string :receive_date
      t.decimal :receive_amount, precision: 10, scale: 2
      t.string :job_code
    end
  end
end
