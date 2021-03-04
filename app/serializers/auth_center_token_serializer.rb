class AuthCenterTokenSerializer < ActiveModel::Serializer
  attributes :access_token, :refresh_token, :expires_in, :token_type
end
