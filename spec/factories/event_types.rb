FactoryBot.define do
  factory :event_type do
    description { 'Make some action' }

    trait :open do
      name { :open }
      template { 'Create claim' }
      order { 10 }
    end

    trait :workflow do
      name { :workflow }
      template { 'Make workflow {workflow}' }
      order { 60 }
    end

    trait :add_workers do
      name { :add_workers }
      template { 'Add workers: {workers}' }
      order { 20 }
    end

    trait :del_workers do
      name { :del_workers }
      template { 'Remov workers: {workers}' }
      order { 30 }
    end

    trait :escalation do
      name { :escalation }
      template { 'Claim escalation' }
      order { 70 }
    end

    trait :postpone do
      name { :postpone }
      template { 'Postpone claim to {new_date}' }
      order { 50 }
    end

    trait :close do
      name { :close }
      template { 'Close claim' }
      order { 1000 }
    end

    trait :comment do
      name { :comment }
      template { 'Make comment {comment}' }
      order { 100 }
    end

    trait :add_files do
      name { :add_files }
      template { 'Add files: {files}' }
      order { 80 }
    end

    trait :del_files do
      name { :del_files }
      template { 'Remove files' }
      order { 30 }
    end

    trait :add_tags do
      name { :add_tags }
      template { 'Add tags: {tags}' }
      order { 900 }
    end

    trait :priority do
      name { :priority }
      template { 'Priority claim to {priority}' }
      order { 40 }
    end

    trait :add_self do
      name { :add_self }
      template { 'Add Self' }
      order { 15 }
    end

    trait :to_user_message do
      name { :to_user_message }
      template { 'To User Message: {message}' }
      order { 120 }
    end

    trait :to_user_accept do
      name { :to_user_accept }
      template { 'To User Accept: {message}' }
      order { 130 }
    end

    trait :from_user_accept do
      name { :from_user_accept }
      template { 'From User Accept: {response}' }
      order { 140 }
    end
  end
end
