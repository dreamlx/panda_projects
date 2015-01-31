class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :client_id
      t.string :name
      t.string :title
      t.boolean :gender
      t.string :mobile
      t.string :tel
      t.string :fax
      t.string :email
      t.string :other
    end
  end
end
