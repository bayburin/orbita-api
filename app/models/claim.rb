# Класс заявки
class Claim < ApplicationRecord
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum status: { opened: 1, at_work: 2, canceled: 3, approved: 4, reopened: 5 }, _suffix: true
  enum priority: { default: 1, low: 2, high: 3 }, _suffix: true

  # TODO: Добавить value claim_user

  def find_or_initialize_work_by_user(user)
    works.where(group_id: user.group_id).first_or_initialize do |w|
      w.group_id = user.group_id
    end
  end

  def runtime
    Runtime.new(
      created_at: created_at,
      updated_at: updated_at,
      finished_at_plan: finished_at_plan,
      finished_at: finished_at
    )
  end

  def runtime=(runtime)
    self.finished_at_plan = runtime.finished_at_plan
    self.finished_at = runtime.finished_at
  end

  def claim_user
    ClaimUser.new(
      id_tn: id_tn,
      tn: tn,
      fio: fio,
      dept: dept,
      user_details: user_details
    )
  end

  def claim_user=(claim_user)
    self.id_tn = claim_user.id_tn
    self.tn = claim_user.tn
    self.fio = claim_user.fio
    self.dept = claim_user.dept
    self.user_details = claim_user.user_details
  end

  def service
    Service.new(id: service_id, name: service_name)
  end

  def service=(service)
    self.service_id = service.id
    self.service_name = service.name
  end

  def app_template
    AppTemplate.new(id: app_template_id, name: app_template_name)
  end

  def app_template=(app_template)
    self.app_template_id = app_template.id
    self.app_template_name = app_template.name
  end
end
