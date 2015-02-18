class MoveClientUserToContacts < ActiveRecord::Migration
  def up
    # keep the original filed of contact in class of client, May remove some day.
    Client.all.each do |client|
      unless (client.person1 || client.title_1 || client.mobile_1 || client.tel_1 || client.fax_1 || client.email_1 || client.address_1 || client.city_1 || client.state_1 || client.country_1  || client.postalcode_1) == ""
        contact1 = Contact.new
        contact1.client_id  = client.id
        contact1.name       = client.person1
        contact1.title      = client.title_1
        contact1.gender     = client.gender1.title
        contact1.mobile     = client.mobile_1
        contact1.tel        = client.tel_1
        contact1.fax        = client.fax_1
        contact1.email      = client.email_1
        contact1.address    = client.address_1
        contact1.city       = client.city_1
        contact1.state      = client.state_1
        contact1.country    = client.country_1
        contact1.postalcode = client.postalcode_1
        contact1.save
      end
      unless (client.person2 || client.title_2 || client.mobile_2 || client.tel_2 || client.fax_2 || client.email_2 || client.address_2 || client.city_2 || client.state_2 || client.country_2  || client.postalcode_2) == ""
        contact2 = Contact.new
        contact2.client_id  = client.id
        contact2.name       = client.person2
        contact2.title      = client.title_2
        contact2.gender     = client.gender2.title
        contact2.mobile     = client.mobile_2
        contact2.tel        = client.tel_2
        contact2.fax        = client.fax_2
        contact2.email      = client.email_2
        contact2.address    = client.address_2
        contact2.city       = client.city_2
        contact2.state      = client.state_2
        contact2.country    = client.country_2
        contact2.postalcode = client.postalcode_2
        contact2.save
      end
      unless (client.person3 || client.title_3 || client.mobile_3 || client.tel_3 || client.fax_3 || client.email_3) == ""
        contact3 = Contact.new
        contact3.client_id   = client.id
        contact3.name       = client.person3
        contact3.title      = client.title_3
        contact3.gender     = client.gender3.title
        contact3.mobile     = client.mobile_3
        contact3.tel        = client.tel_3
        contact3.fax        = client.fax_3
        contact3.email      = client.email_3
        contact3.save
      end
    end
  end

  def down
    Contact.delete_all
  end
end
