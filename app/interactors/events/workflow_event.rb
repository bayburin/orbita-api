module Events
  # Класс-обработчик события выполнения некоторого действия во внешней системе. Класс проверяет наличие работы, добавляет работника и
  # логирует событие в системе.
  class WorkflowEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateWorkflow
  end
end
