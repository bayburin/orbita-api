module Events
  # Создает запись в модели Workflow на основании полученного события Event.
  class CreateWorkflow
    include Interactor

    delegate :event, :work, :workflow, :user, :claim, to: :context

    def call
      context.workflow = work.workflows.build(
        message: event.payload['message'],
        sender: user,
        claim: claim
      )

      context.fail!(error: workflow.errors.full_messages) unless workflow.save
    end
  end
end
