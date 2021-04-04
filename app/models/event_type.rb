# Класс, описывающий тип и шаблон сообщений для истории заявок, инцидентов и т.д.
class EventType < ApplicationRecord
  has_many :histories, dependent: :nullify

  enum name: {
    open: 1,          # Заявка создана
    workflow: 2,      # Выполнено действие
    status: 3,        # Изменен статус
    add_workers: 4,   # Добавлены исполнители
    del_workers: 5,   # Удалены исполнители
    escalation: 6,    # Эскалация
    postpone: 7,      # Изменен дедлайн
    close: 8,         # Заявка закрыта
    comment: 9,       # Добавлен комментарий
    add_files: 10,    # Добавлены файлы
    del_files: 11,    # Удалены файлы
    add_tags: 12,     # Добавлены теги
    priority: 13      # Изменен приоритет
  }
end
