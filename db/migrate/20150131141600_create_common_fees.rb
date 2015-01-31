class CreateCommonFees < ActiveRecord::Migration
  def change
    create_table :common_fees do |t|
      t.integer :period_id
      t.integer :person_id
      t.decimal :common_fee
      t.timestamp :created_on
      t.timestamp :updated_on
    end
  end
end
