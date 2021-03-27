FactoryBot.define do
  factory :message do
    sender { build(:admin) }
    message { Faker::Hipster.paragraph }
  end

  factory :workflow, parent: :message, class: 'Workflow' do
    work { build(:work) }
  end

  factory :comment, parent: :message, class: 'Comment' do
    claim { build(:claim) }
  end
end
