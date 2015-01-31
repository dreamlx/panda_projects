class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :username
      t.string :email
      t.string :picked
      t.integer :item_id
    end
  end
end
