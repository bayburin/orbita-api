module Events
  # Класс-обработчик события закрытия заявки во внешней системе. Класс закрывает заявку и логирует событие в системе.
  class CloseEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CloseClaim, Astraea::SyncCloseClaim
  end
end
