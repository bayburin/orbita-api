module Events
  # Класс-обработчик события выполнения некоторого действия во внешней системе. Класс проверяет наличие работы, добавляет работника и
  # логирует событие в системе.
  class ToUserAcceptEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateToUserAccept
  end
end
