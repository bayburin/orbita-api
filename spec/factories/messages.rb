FactoryBot.define do
  factory :message do
    claim { build(:claim) }
    sender { build(:admin) }
    message { Faker::Hipster.paragraph }
  end

  factory :workflow, parent: :message, class: 'Workflow' do
    work { build(:work) }
  end

  factory :comment, parent: :message, class: 'Workflow' do
  end
end
