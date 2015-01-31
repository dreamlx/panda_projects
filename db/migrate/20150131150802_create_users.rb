class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :person_id
      t.string :hashed_password
      t.boolean :auth
      t.string :other1
      t.string :other2
    end
  end
end
