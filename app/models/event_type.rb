# Класс, описывающий тип и шаблон сообщений для истории заявок, инцидентов и т.д.
class EventType < ApplicationRecord
  has_many :histories, dependent: :nullify

  enum name: { workflow: 1, comment: 2, postpone: 3, close: 4 }
end
