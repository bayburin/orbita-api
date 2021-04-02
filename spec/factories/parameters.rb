FactoryBot.define do
  factory :parameter do
    name { Faker::Device.manufacturer }
    value { Faker::Device.model_name }
  end
end
