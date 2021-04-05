FactoryBot.define do
  factory :worker do
    work
    user factory: :admin
  end
end
