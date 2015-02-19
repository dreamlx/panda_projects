class MergePersonToUsers < ActiveRecord::Migration
  def up
    Person.all.each do |person|
      user = User.find_or_create_by(email: "#{person.name.downcase.tr(" ", ".")}@think-bridge.com")
      user.person_id          = person.id
      user.created_on         = person.created_on
      user.updated_on         = person.updated_on
      user.chinese_name       = person.chinese_name
      user.english_name       = person.english_name
      user.employee_number    = person.employee_number
      user.department         = person.department.title if person.department
      user.grade              = person.grade
      user.charge_rate        = person.charge_rate
      user.employeement_date  = person.employeement_date
      user.address            = person.address
      user.postalcode         = person.postalcode
      user.mobile             = person.mobile
      user.tel                = person.tel
      user.extension          = person.extension
      user.gender             = person.gender.title if person.gender
      user.status             = person.status.title if person.status
      user.GMU                = person.GMU.title if person.GMU
      user.password           = rand(100000..999999)
      user.save!
    end
  end

  def down
    User.where(name: nil).delete_all
  end
end
