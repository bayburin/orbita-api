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

  factory :to_user_message, parent: :message, class: 'ToUserMessage' do
    work
  end

  factory :to_user_accept, parent: :message, class: 'ToUserAccept' do
    work
    accept_value { true }
    accept_endpoint { 'https://fake_endpoint' }
    accept_comment { 'fake-comment' }
  end
end
