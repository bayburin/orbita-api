FactoryBot.define do
  factory :parameter do
    schema_version { 1 }
    payload { {}.as_json }
  end
end
