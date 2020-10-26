FactoryBot.define do
  factory :history do
    work { build(:work) }
    user { build(:admin) }
    event_type { build(:event_type) }
    action { 'TestAction' }
  end
end
