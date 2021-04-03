module Events
  # Класс-обработчик события выполнения некоторого действия во внешней системе. Класс проверяет наличие работы, добавляет работника и
  # логирует событие в системе.
  class WorkflowEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateWorkflow, Histories::CreateWorkflow

    around do |interactor|
      ActiveRecord::Base.transaction do
        interactor.call
      end
    end
  end
end
