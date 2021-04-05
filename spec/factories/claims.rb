FactoryBot.define do
  factory :claim do
    description { 'test description' }
    status { nil }
    priority { nil }
    rating { nil }
    finished_at_plan { Claim.default_finished_at_plan }
    finished_at { nil }

    after(:build) do |claim, _ev|
      claim.source_snapshot ||= build(:source_snapshot, claim: claim)
    end
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
