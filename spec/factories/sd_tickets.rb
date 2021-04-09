FactoryBot.define do
  factory :sd_ticket, class: ServiceDesk::Ticket do
    initialize_with { new(attributes) }

    identity { 1 }
    name { 'fake identity name' }
    sla { 123 }
    service factory: :sd_service
  end
end
