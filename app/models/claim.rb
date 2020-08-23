# Класс заявки
class Claim < ApplicationRecord
  has_many :works, dependent: :destroy

  # TODO: Добавить value claim_user
  # TODO: Добавить value time_info
end
