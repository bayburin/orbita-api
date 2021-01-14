FactoryBot.define do
  factory :group do
    name { Faker::Number.number(digits: 6) }
    description { 'Test Group' }
  end
end
