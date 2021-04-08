FactoryBot.define do
  factory :runtime do
    initialize_with { new(attributes) }

    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    finished_at_plan { Time.zone.now + 3.days }
    finished_at { nil }
  end
end
