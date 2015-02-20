class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.decimal :hours, precision: 10, scale: 2, default: 0

      t.timestamps null: false
    end
    add_foreign_key :bookings, :users
    add_foreign_key :bookings, :projects
  end
end
