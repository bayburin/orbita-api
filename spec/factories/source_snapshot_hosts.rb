FactoryBot.define do
  factory :source_snapshot_host, class: Snapshot::Host do
    initialize_with { new(attributes) }

    dns { Faker::Internet.domain_word }
    source_ip { Faker::Internet.ip_v4_address }
    destination_ip { Faker::Internet.ip_v4_address }
    mac { Faker::Internet.mac_address }
    invent_num { '765133' }
    os { 'W7E' }
    netbios { 'fake-netbiod' }
  end
end
