# Класс заявки
class Claim < ApplicationRecord
  has_many :works, dependent: :destroy

  enum status: { opened: 1, at_work: 2, canceled: 3, approved: 4, reopened: 5 }, _suffix: true
  enum priority: { default: 1, low: 2, high: 3 }, _suffix: true

  # TODO: Добавить value claim_user

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
end
