FactoryBot.define do
  factory :claim do
    service_name { "#{Faker::Company.name} service" }
    app_template_name { "#{Faker::Company.name} template name" }
    status { nil }
    priority { nil }
    id_tn { Faker::Number.number(digits: 6) }
    tn { Faker::Number.number(digits: 6) }
    fio { Faker::Name.name }
    dept { 714 }
    user_details { {} }
    attrs { {} }
    rating { nil }
    finished_at_plan { Time.zone.now + 2.days }
    finished_at { nil }
  end
end
