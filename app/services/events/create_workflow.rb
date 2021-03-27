module Events
  # Создает запись хода работы в таблице messages на основании полученного события Event.
  class CreateWorkflow
    include Interactor

    delegate :event, :workflow, to: :context

    def call
      context.workflow = event.work.workflows.build(
        message: event.payload['message'],
        sender: event.user
      )

      context.fail!(error: workflow.errors.full_messages) unless workflow.save
    end
  end
end
