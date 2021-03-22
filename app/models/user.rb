# Класс, описывающий пользователя.
class User < ApplicationRecord
  devise

  has_many :histories, dependent: :nullify

  belongs_to :role
  belongs_to :group, optional: true

  attr_accessor :access_token, :refresh_token, :expires_in, :token_type

  scope :default_workers, -> { where(is_default_worker: true) }

  def self.authenticate_employee(id_tn)
    user = employee_user
    return unless user

    user_info = Employees::Loader.new(:load).load(id_tn)
    raise 'Не удалось загрузить данные о пользователе.' unless user_info

    user.fill_by_employee(Employee.new(user_info))
    user
  end

  def self.employee_user
    User.find_by(role: Role.find_by(name: :employee))
  end

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

  def fill_by_employee(employee)
    self.tn = employee.employeePositions.first.personnelNo
    self.id_tn = employee.id
    self.login = employee.employeeContact.login
    self.fio = employee.fio
    self.work_tel = employee.employeeContact.phone.first
    self.email = employee.employeeContact.email.first
  end
end
