class CreateDicts < ActiveRecord::Migration
  def change
    create_table :dicts do |t|
      t.string :category
      t.string :code
      t.string :title
    end
  end
end
