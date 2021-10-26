FactoryBot.define do
  factory :parameter do
    version { 1 }
    payload { {}.as_json }
  end
end
