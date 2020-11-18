FactoryBot.define do
  factory :claim do
    source_snapshot { build(:source_snapshot) }
    status { nil }
    priority { nil }
    attrs { {} }
    rating { nil }
    finished_at_plan { Time.zone.now + 2.days }
    finished_at { nil }
  end

  factory :application, parent: :claim, class: Application do
    service_id { 1 }
    app_template_id { 2 }
    service_name { "#{Faker::Company.name} service" }
    app_template_name { "#{Faker::Company.name} template name" }
  end

  factory :case, parent: :claim, class: Case do
  end
end
