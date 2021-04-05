FactoryBot.define do
  factory :employee do
    initialize_with { new(attributes) }

    lastName { Faker::Name.last_name }
    firstName { Faker::Name.first_name }
    middleName { Faker::Name.middle_name }
    id { Faker::Number.number(digits: 5) }
    dateOfBirth { Faker::Date.in_date_period }
    sex { 'М' }
    employeePositions { [build(:employee_position)] }
    employeeContact factory: :employee_contact
  end

  factory :employee_contact do
    initialize_with { new(attributes) }

    id { Faker::Number.number(digits: 5) }
    position { '1-304' }
    phone { ['12-34'] }
    email { [Faker::Internet.email] }
    login { 'AdLogin' }
  end

  factory :employee_position do
    initialize_with { new(attributes) }

    employeeId { Faker::Number.number(digits: 5) }
    personnelNo { Faker::Number.number(digits: 5) }
    departmentForAccounting { Faker::Number.number(digits: 3) }
  end
end
