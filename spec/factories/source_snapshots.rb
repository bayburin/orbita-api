FactoryBot.define do
  factory :source_snapshot do
    claim
    id_tn { Faker::Number.number(digits: 6) }
    tn { Faker::Number.number(digits: 6) }
    fio { Faker::Name.name }
    dept { 714 }
    user_attrs { { phone: '12-34', email: 'bayburin' } }
    dns { Faker::Internet.domain_name }
    domain_user { Faker::Internet.domain_word }
    source_ip { Faker::Internet.ip_v4_address }
    destination_ip { Faker::Internet.private_ip_v4_address }
    mac { Faker::Internet.mac_address }
    invent_num { '766123' }
    host_location { '3-123' }
    netbios { 'fake_netbios' }
    os { Faker::Computer.os }
  end
end
