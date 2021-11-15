FactoryBot.define do
  factory :claim_application do
    # claim { build(:claim) }
    # application { build(:oauth_application) }
    integration_id { Faker::Number.number(digits: 5) }
  end
end
