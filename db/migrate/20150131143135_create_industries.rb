class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.string :code
      t.string :title
    end
  end
end
