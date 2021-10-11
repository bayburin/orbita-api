module Events
  # Создает запись хода работы в таблице messages на основании полученного события Event.
  class CreateWorkflow
    include Interactor

    delegate :event, :history_store, :workflow, to: :context

    def call
      context.workflow = event.work.workflows.build(
        message: event.payload['message'],
        sender: event.user
      )

      history_store.work = event.work
      history_store.add(Histories::WorkflowType.new(workflow: event.payload['message']).build)

      if workflow.save
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      else
        context.fail!(error: workflow.errors.full_messages)
      end
    end
  end
end
