class MoveFromPersonToUsers < ActiveRecord::Migration
  def up
    Project.all.each do |e|
      e.update_column(:partner_id,          (User.find_by_person_id(e.partner_id)         ? User.find_by_person_id(e.partner_id).id         : nil)) if e.partner_id
      e.update_column(:manager_id,          (User.find_by_person_id(e.manager_id)         ? User.find_by_person_id(e.manager_id).id         : nil)) if e.manager_id
      e.update_column(:referring_id,        (User.find_by_person_id(e.referring_id)       ? User.find_by_person_id(e.referring_id).id       : nil)) if e.referring_id
      e.update_column(:billing_partner_id,  (User.find_by_person_id(e.billing_partner_id) ? User.find_by_person_id(e.billing_partner_id).id : nil)) if e.billing_partner_id
      e.update_column(:billing_manager_id,  (User.find_by_person_id(e.billing_manager_id) ? User.find_by_person_id(e.billing_manager_id).id : nil)) if e.billing_manager_id
    end

    add_column :clients, :user_id, :integer
    Client.all.each do |e|
      e.update_column(:user_id, (User.find_by_person_id(e.person_id) ? User.find_by_person_id(e.person_id).id : nil)) if e.person_id
    end

    add_column :personalcharges, :user_id, :integer

    Personalcharge.all.each do |e|
      e.update_column(:user_id, (User.find_by_person_id(e.person_id) ? User.find_by_person_id(e.person_id).id : nil)) if e.person_id
    end

    add_column :commissions, :user_id, :integer
    Commission.all.each do |e|
      e.update_column(:user_id, (User.find_by_person_id(e.person_id) ? User.find_by_person_id(e.person_id).id : nil)) if e.person_id
    end

    add_column :billings, :user_id, :integer
    Billing.all.each do |e|
      e.update_column(:user_id, (User.find_by_person_id(e.person_id) ? User.find_by_person_id(e.person_id).id : nil)) if e.person_id
    end
  end

  def down
    Project.all.each do |e|
      e.update(partner_id:          e.partner.person.id)         if e.partner && e.partner.person
      e.update(manager_id:          e.manager.person.id)         if e.manager && e.manager.person
      e.update(referring_id:        e.referring.person.id)       if e.referring && e.referring.person
      e.update(billing_partner_id:  e.billing_partner.person.id) if e.billing_partner && e.billing_partner.person
      e.update(billing_manager_id:  e.billing_manager.person.id) if e.billing_manager && e.billing_manager.person
    end

    remove_column :clients, :user_id, :integer
    remove_column :personalcharges, :user_id, :integer
    remove_column :commissions, :user_id, :integer
    remove_column :billings, :user_id, :integer
  end
end
