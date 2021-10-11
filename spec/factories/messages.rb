FactoryBot.define do
  factory :message do
    sender factory: :admin
    message { Faker::Hipster.paragraph }
  end

  factory :workflow, parent: :message, class: 'Workflow' do
    work
  end

  factory :comment, parent: :message, class: 'Comment' do
    claim
  end
end
