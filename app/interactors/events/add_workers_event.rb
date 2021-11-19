module Events
  # Класс-обработчик события дообавления исполнителей. Класс добавляет указанных исполнителей и
  # логирует событие в системе.
  class AddWorkersEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateWorkers
  end
end
