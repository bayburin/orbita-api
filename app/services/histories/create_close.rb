module Histories
  # Создает запись истории о событии с типом "close".
  class CreateClose
    include Interactor

    delegate :event, :history, to: :context

    def call
      context.history = event.work.histories.build(
        event_type: event.event_type,
        user: event.user,
        action: event.event_type.template
      )

      context.fail!(error: history.errors.full_messages) unless history.save
    end
  end
end