class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user, index: true
      t.references :period, index: true

      t.timestamps null: false
    end
    add_foreign_key :reports, :users
    add_foreign_key :reports, :periods
  end
end
