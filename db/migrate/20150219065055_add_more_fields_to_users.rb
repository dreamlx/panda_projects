class AddMoreFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :created_on, :datetime
    add_column :users, :updated_on, :datetime
    add_column :users, :chinese_name, :string
    add_column :users, :english_name, :string
    add_column :users, :employee_number, :string
    add_column :users, :department, :string
    add_column :users, :grade, :string
    add_column :users, :charge_rate, :decimal, precision: 10, scale: 2
    add_column :users, :employeement_date, :date
    add_column :users, :address, :string
    add_column :users, :postalcode, :string
    add_column :users, :mobile, :string
    add_column :users, :tel, :string
    add_column :users, :extension, :string
    add_column :users, :gender, :string
    add_column :users, :status, :string
    add_column :users, :GMU, :string
    add_column :users, :role, :string
  end

  def down
    remove_column :users, :created_on, :datetime
    remove_column :users, :updated_on, :datetime
    remove_column :users, :chinese_name, :string
    remove_column :users, :english_name, :string
    remove_column :users, :employee_number, :string
    remove_column :users, :department, :string
    remove_column :users, :grade, :string
    remove_column :users, :charge_rate, :decimal, precision: 10, scale: 2
    remove_column :users, :employeement_date, :date
    remove_column :users, :address, :string
    remove_column :users, :postalcode, :string
    remove_column :users, :mobile, :string
    remove_column :users, :tel, :string
    remove_column :users, :extension, :string
    remove_column :users, :gender, :string
    remove_column :users, :status, :string
    remove_column :users, :GMU, :string
    remove_column :users, :role, :string
  end
end
