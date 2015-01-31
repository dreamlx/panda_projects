class CreateLimitFees < ActiveRecord::Migration
  def change
    create_table :limit_fees do |t|
      t.integer :period_id
      t.integer :person_id
      t.decimal :limit_fee
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :remark
    end
  end
end
