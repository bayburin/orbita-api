class AuthCenterToken < Dry::Struct
  include ActiveModel::Serialization
  transform_keys(&:to_sym)

  attribute :access_token, Types::String.optional
  attribute? :refresh_token, Types::String.optional
  attribute :expires_in, Types::Coercible::Integer.optional
  attribute :token_type, Types::String.optional
end
