# Общий класс заявки
class Claim < ApplicationRecord
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :source_snapshot, dependent: :destroy

  enum priority: { default: 1, low: 2, high: 3 }, _suffix: true

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
end
