FactoryBot.define do
  factory :event_type do
    description { 'Make some action' }

    trait :workflow do
      name { 'workflow' }
      template { 'Make workflow {message}' }
    end

    trait :add_self do
      name { 'add_self' }
      template { 'Added self' }
    end
  end
end
