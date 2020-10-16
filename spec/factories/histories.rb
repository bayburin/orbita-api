FactoryBot.define do
  factory :history do
    work { build(:work) }
    user { build(:admin) }
    action { 'TestAction' }
    action_type { nil }
  end
end
