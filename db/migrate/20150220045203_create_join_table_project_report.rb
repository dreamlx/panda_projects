class CreateJoinTableProjectReport < ActiveRecord::Migration
  def change
   create_join_table :projects, :reports do |t|
      t.index [:project_id, :report_id]
      t.index [:report_id, :project_id]
    end
  end
end
