module Histories
  # Создает запись истории о событии с типом "postpone".
  class CreatePostpone
    include Interactor

    delegate :event, :history, to: :context

    def call
      action = event.event_type.template
                 .gsub(/{old_datetime}/, event.payload['old_datetime'])
                 .gsub(/{new_datetime}/, event.payload['new_datetime'])

      context.history = event.work.histories.build(
        event_type: event.event_type,
        user: event.user,
        action: action
      )

      context.fail!(error: history.errors.full_messages) unless history.save
    end
  end
end
