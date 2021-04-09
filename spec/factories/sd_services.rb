FactoryBot.define do
  factory :sd_service, class: ServiceDesk::Service do
    initialize_with { new(attributes) }

    id { 2 }
    name { 'fake service name' }
  end
end
