FactoryBot.define do
  factory :employee_info do
    initialize_with { new(attributes) }

    lastName { Faker::Name.last_name }
    firstName { Faker::Name.first_name }
    middleName { Faker::Name.middle_name }
    id { Faker::Number.number(digits: 5) }
    dateOfBirth { Faker::Date.in_date_period }
    sex { 'М' }
    employeePositions { [build(:employee_info_position)] }
    employeeContact factory: :employee_info_contact
  end

  factory :employee_info_contact, class: EmployeeInfo::EmployeeContact do
    initialize_with { new(attributes) }

    id { Faker::Number.number(digits: 5) }
    position { '1-304' }
    phone { ['12-34'] }
    email { [Faker::Internet.email] }
    login { 'AdLogin' }
  end

  factory :employee_info_position, class: EmployeeInfo::EmployeePosition do
    initialize_with { new(attributes) }

    employeeId { Faker::Number.number(digits: 5) }
    personnelNo { Faker::Number.number(digits: 5) }
    departmentForAccounting { Faker::Number.number(digits: 3) }
  end
end
