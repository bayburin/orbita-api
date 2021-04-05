FactoryBot.define do
  factory :work do
    claim
    group
    title { 'Test title' }
    status { nil }
    attrs { {} }
  end
end
