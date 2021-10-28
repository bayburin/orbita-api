module Events
  # Создает запись хода работы в таблице messages на основании полученного события Event.
  class CreateToUserMessage
    include Interactor

    delegate :event, :history_store, :to_user_message, to: :context

    def call
      context.to_user_message = event.work.to_user_messages.build(
        message: event.payload['message'],
        sender: event.user
      )

      history_store.add(Histories::ToUserMessageType.new(message: event.payload['message']).build)

      if to_user_message.save
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      else
        context.fail!(error: to_user_message.errors.full_messages)
      end
    end
  end
end
