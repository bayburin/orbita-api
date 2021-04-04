FactoryBot.define do
  factory :oauth_access_token, class: Doorkeeper::AccessToken do
    application { create(:oauth_application) }
  end
end
