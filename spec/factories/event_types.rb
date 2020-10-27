FactoryBot.define do
  factory :event_type do
    description { 'Make some action' }

    trait :workflow do
      name { 'workflow' }
      template { 'Make workflow {message}' }
    end
  end
end
