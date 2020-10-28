FactoryBot.define do
  factory :event_type do
    description { 'Make some action' }

    trait :workflow do
      name { 'workflow' }
      template { 'Make workflow {message}' }
    end

    trait :comment do
      name { 'comment' }
      template { 'Make comment {message}' }
    end

    trait :add_self do
      name { 'add_self' }
      template { 'Added self' }
    end

    trait :postpone do
      name { 'postpone' }
      template { 'Postpone claim from {old_date} to {new_date}' }
    end

    trait :close do
      name { 'close' }
      template { 'Close claim' }
    end
  end
end
