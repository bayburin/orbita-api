FactoryBot.define do
  factory :auth_center_token do
    initialize_with { new(attributes) }

    access_token { 'fake-access-token' }
    refresh_token { 'fake-refresh-token' }
    expires_in { 3600 }
    token_type { 'Bearer' }
  end
end
