class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :number
      t.date :starting_date
      t.date :ending_date
      t.timestamp :created_on
    end
  end
end
