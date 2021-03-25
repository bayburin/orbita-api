FactoryBot.define do
  factory :claim do
    source_snapshot { build(:source_snapshot) }
    status { nil }
    priority { nil }
    attrs { {} }
    rating { nil }
    finished_at_plan { Claim.default_finished_at_plan }
    finished_at { nil }
  end

  factory :sd_request, parent: :claim, class: SdRequest do
    service_id { 1 }
    ticket_identity { 2 }
    service_name { "#{Faker::Company.name} service" }
    ticket_name { "#{Faker::Company.name} ticket name" }
  end

  factory :case, parent: :claim, class: Case do
  end
end
