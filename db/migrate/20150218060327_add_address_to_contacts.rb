class AddAddressToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :address, :string
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :country, :string
    add_column :contacts, :postalcode, :string
    remove_column :contacts, :other, :string
    change_column :contacts, :gender, :string
  end

  def down
    remove_column :contacts, :address, :string
    remove_column :contacts, :city, :string
    remove_column :contacts, :state, :string
    remove_column :contacts, :country, :string
    remove_column :contacts, :postalcode, :string
    add_column :contacts, :other, :string
    change_column :contacts, :gender, :boolean
  end
end
