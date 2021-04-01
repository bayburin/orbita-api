FactoryBot.define do
  factory :worker do
    work { build(:work) }
    user { build(:manager) }
  end
end
