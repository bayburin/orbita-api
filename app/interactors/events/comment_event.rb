module Events
  # Класс-обработчик события добавления комментария во внешней системе. Класс проверяет наличие работы, добавляет работника и
  # логирует событие в системе.
  class CommentEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateComment
  end
end
