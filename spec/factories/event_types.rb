FactoryBot.define do
  factory :event_type do
    description { 'Make some action' }

    trait :created do
      name { :created }
      template { 'Create claim' }
    end

    trait :workflow do
      name { :workflow }
      template { 'Make workflow {message}' }
    end

    trait :comment do
      name { :comment }
      template { 'Make comment {message}' }
    end

    trait :add_workers do
      name { :add_workers }
      template { 'Added workers: {workers}' }
    end

    trait :del_workers do
      name { :del_workers }
      template { 'Removed workers' }
    end

    trait :escalation do
      name { :escalation }
      template { 'Claim escalation' }
    end

    trait :postpone do
      name { :postpone }
      template { 'Postpone claim to {new_date}' }
    end

    trait :close do
      name { :close }
      template { 'Close claim' }
    end

    trait :add_files do
      name { :add_files }
      template { 'Added files: {files}' }
    end

    trait :add_tags do
      name { :add_tags }
      template { 'Added tags: {tags}' }
    end

    trait :priority do
      name { :priority }
      template { 'Priority claim to {priority}' }
    end
  end
end
