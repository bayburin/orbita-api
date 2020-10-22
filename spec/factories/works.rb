FactoryBot.define do
  factory :work do
    claim { build(:claim) }
    group { build(:group) }
    title { 'Test title' }
    status { nil }
    attrs { {} }
  end
end
