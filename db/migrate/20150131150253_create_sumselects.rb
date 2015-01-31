class CreateSumselects < ActiveRecord::Migration
  def change
    create_table :sumselects do |t|
      t.string :type
      t.integer :count_item
    end
  end
end
