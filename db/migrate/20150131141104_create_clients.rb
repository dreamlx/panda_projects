class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :chinese_name
      t.string :english_name
      t.integer :person_id
      t.string :address_1
      t.string :person1
      t.string :person2
      t.string :address_2
      t.string :city_1
      t.string :city_2
      t.string :state_1
      t.string :state_2
      t.string :country_1
      t.string :country_2
      t.string :postalcode_1
      t.string :postalcode_2
      t.string :title_1
      t.string :title_2
      t.integer :gender1_id
      t.integer :gender2_id
      t.string :mobile_1
      t.string :mobile_2
      t.string :tel_1
      t.string :tel_2
      t.string :fax_1
      t.string :fax_2
      t.string :email_1
      t.string :email_2
      t.string :description
      t.integer :category_id
      t.integer :status_id
      t.integer :region_id
      t.integer :industry_id
      t.string :client_code
      t.string :person3
      t.string :title_3
      t.integer :gender3_id
      t.string :mobile_3
      t.string :tel_3
      t.string :fax_3
      t.string :email_3
      t.timestamp :created_on
      t.timestamp :updated_on
    end
  end
end
