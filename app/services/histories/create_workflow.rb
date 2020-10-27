module Histories
  # Создает запись истории о событии с типом "workflow".
  class CreateWorkflow
    include Interactor

    delegate :event, :history, to: :context

    def call
      context.history = event.work.histories.build(
        event_type: event.event_type,
        user: event.user,
        action: event.event_type.template.gsub(/{workflow}/, event.payload['message'])
      )

      context.fail!(error: history.errors.full_messages) unless history.save
    end
  end
end
