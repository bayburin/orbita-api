class AuthCenterToken
  include ActiveModel::Serialization
  include Virtus.value_object

  values do
    attribute :access_token, String
    attribute :refresh_token, String
    attribute :expires_in, String
    attribute :token_type, String
  end
end
