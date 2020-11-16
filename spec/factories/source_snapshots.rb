FactoryBot.define do
  factory :source_snapshot do
    id_tn { Faker::Number.number(digits: 6) }
    tn { Faker::Number.number(digits: 6) }
    fio { Faker::Name.name }
    dept { 714 }
    user_attrs { { email: 'bayburin' } }
    dns { Faker::Internet.domain_name }
    domain_user { Faker::Internet.domain_word }
    source_ip { Faker::Internet.ip_v4_address }
    destination_ip { Faker::Internet.private_ip_v4_address }
    mac { Faker::Internet.mac_address }
    invent_num { '766123' }
    netbios { 'fake_netbios' }
    os { Faker::Computer.os }
  end
end