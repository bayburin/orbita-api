FactoryBot.define do
  factory :source_snapshot_user, class: Snapshot::User  do
    initialize_with { new(attributes) }

    id_tn { Faker::Number.number(digits: 6) }
    tn { Faker::Number.number(digits: 6) }
    fio { Faker::Name.name_with_middle }
    dept { Faker::Number.number(digits: 3) }
    user_attrs { {} }
    domain_user { 'LoginAD' }
  end
end
