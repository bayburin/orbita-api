FactoryBot.define do
  factory :sd_ticket, class: ServiceDesk::Ticket do
    initialize_with { new(attributes) }

    identity { 1 }
    name { 'fake identity name' }
    service factory: :sd_service
    responsible_users { [ { tn: 1 }, { tn: 2 } ] }
    sla { 123 }
  end
end
