module Events
  # Класс-обработчик события удаления исполнителей. Класс добавляет указанных исполнителей и
  # логирует событие в системе.
  class DelWorkersEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, DeleteWorkers
  end
end
