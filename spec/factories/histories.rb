FactoryBot.define do
  factory :history do
    work
    user factory: :admin

    transient { event_type_name { :open } }

    trait :open do
      transient { event_type_name { :open } }
    end

    trait :workflow do
      transient { event_type_name { :workflow } }
    end

    trait :add_workers do
      transient { event_type_name { :add_workers } }
    end

    trait :del_workers do
      transient { event_type_name { :del_workers } }
    end

    trait :escalation do
      transient { event_type_name { :escalation } }
    end

    trait :postpone do
      transient { event_type_name { :postpone } }
    end

    trait :close do
      transient { event_type_name { :close } }
    end

    trait :comment do
      transient { event_type_name { :comment } }
    end

    trait :add_files do
      transient { event_type_name { :add_files } }
    end

    trait :del_files do
      transient { event_type_name { :del_files } }
    end

    trait :add_tags do
      transient { event_type_name { :add_tags } }
    end

    trait :priority do
      transient { event_type_name { :priority } }
    end

    after(:build) do |history, ev|
      history.event_type = EventType.find_by(name: ev.event_type_name) || create(:event_type, ev.event_type_name.to_sym)
      history.action = history.event_type.template
      history.order = history.event_type.order
    end
  end
end
