# Класс заявки
class Claim < ApplicationRecord
  has_many :works, dependent: :destroy

  enum status: { opened: 1, at_work: 2, canceled: 3, approved: 4, reopened: 5 }, _suffix: true
  enum priority: { default: 1, low: 2, high: 3 }, _suffix: true

  # TODO: Добавить value claim_user
  # TODO: Добавить value time_info
end
