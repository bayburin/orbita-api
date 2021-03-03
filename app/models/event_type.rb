# Класс, описывающий тип и шаблон сообщений для истории заявок, инцидентов и т.д.
class EventType < ApplicationRecord
  has_many :histories, dependent: :nullify

  enum name: { created: 1, workflow: 2, comment: 3, postpone: 4, close: 5 }
end
