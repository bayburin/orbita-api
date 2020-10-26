module Events
  # Класс-обработчик события выполнения некоторого действия во внешней системе (Событие workflow в системе).
  class WorkflowEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, CreateWorkflow

    around do |interactor|
      ActiveRecord::Base.transaction do
        interactor.call
      end
    end
  end
end
