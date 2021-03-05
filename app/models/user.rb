# Класс, описывающий пользователя.
class User < ApplicationRecord
  devise

  has_many :histories, dependent: :nullify

  belongs_to :role
  belongs_to :group, optional: true

  attr_accessor :access_token, :refresh_token, :expires_in, :token_type

  def auth_center_token
    AuthCenterToken.new(
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: expires_in,
      token_type: token_type
    )
  end

  def auth_center_token=(auth_center_token)
    self.access_token = auth_center_token.access_token
    self.refresh_token = auth_center_token.refresh_token
    self.expires_in = auth_center_token.expires_in
    self.token_type = auth_center_token.token_type
  end

  def role?(role_name)
    role.name.to_sym == role_name.to_sym
  end

  def one_of_roles?(*roles)
    roles.include?(role.name.to_sym)
  end

  def belongs_to_claim?(claim)
    claim.works.includes(:workers).any? { |work| work.workers.any? { |worker| worker.user_id == id } }
  end
end
