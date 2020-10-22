# Класс, описывающий история действий пользователей системы.
class History < ApplicationRecord
  belongs_to :work
  belongs_to :user

  enum action_type: { workflow: 1, comment: 2, add_worker: 3, postpone: 4, close: 5 }, _suffix: true
end
