FactoryBot.define do
  factory :work do
    claim { build(:claim) }
    title { 'Test title' }
    status { nil }
    attrs { {} }
  end
end
