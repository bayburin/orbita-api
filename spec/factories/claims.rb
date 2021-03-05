FactoryBot.define do
  factory :claim do
    source_snapshot { build(:source_snapshot) }
    status { nil }
    priority { nil }
    attrs { {} }
    rating { nil }
    finished_at_plan { nil }
    finished_at { nil }
  end

  factory :sd_request, parent: :claim, class: SdRequest do
    service_id { 1 }
    app_template_id { 2 }
    service_name { "#{Faker::Company.name} service" }
    app_template_name { "#{Faker::Company.name} template name" }
  end

  factory :case, parent: :claim, class: Case do
  end
end
