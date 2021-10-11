FactoryBot.define do
  factory :user do
    group
    id_tn { Faker::Number.number(digits: 6) }
    tn { Faker::Number.number(digits: 6) }
    login { 'LoginAD' }
    fio { Faker::Name.name_with_middle }
    work_tel { '12-34' }
    mobile_tel { '8-999-999-99-99' }
    email { Faker::Internet.email }
    is_vacation { false }

    after(:build) do |user, _ev|
      user.auth_center_token = build(:auth_center_token)
    end
  end

  factory :admin, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :admin) || create(:admin_role)
    end
  end

  factory :manager, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :manager) || create(:manager_role)
    end
  end

  factory :employee, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :employee) || create(:employee_role)
    end
  end

  trait :default_worker do
    after(:build) do |user, _ev|
      user.is_default_worker = true
    end
  end
end
