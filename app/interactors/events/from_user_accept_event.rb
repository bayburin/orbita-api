module Events
  # Класс-обработчик события выполнения некоторого действия во внешней системе. Класс проверяет наличие работы, добавляет работника и
  # логирует событие в системе.
  class FromUserAcceptEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateFromUserAccept, SendUserAnswer
  end
end
