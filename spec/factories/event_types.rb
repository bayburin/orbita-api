FactoryBot.define do
  factory :event_type do
    name { 'action' }
    description { 'Make some action' }
    template { 'Make action {message}' }
  end
end
