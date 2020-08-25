FactoryBot.define do
  factory :user do
    id_tn { Faker::Number.number(digits: 6) }
    tn { Faker::Number.number(digits: 6) }
    fio { Faker::Name.name }
    work_tel { '12-34' }
    mobile_tel { '8-999-999-99-99' }
    email { Faker::Internet.email }
    is_vacation { false }
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
end
