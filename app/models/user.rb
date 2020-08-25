# Класс, описывающий пользователя.
class User < ApplicationRecord
  devise

  belongs_to :role
  belongs_to :group, optional: true

  def role?(role_name)
    role.name.to_sym == role_name.to_sym
  end

  def one_of_roles?(*roles)
    roles.include?(role.name.to_sym)
  end
end
