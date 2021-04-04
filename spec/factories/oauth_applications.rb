FactoryBot.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name { 'fake-application' }
    redirect_uri { '' }
    scopes { '' }
  end
end
