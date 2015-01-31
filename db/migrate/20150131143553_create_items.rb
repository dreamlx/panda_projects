class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :code
      t.string :titlename
      t.string :img_url
    end
  end
end
