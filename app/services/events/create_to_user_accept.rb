module Events
  # Создает запись хода работы в таблице messages на основании полученного события Event.
  class CreateToUserAccept
    include Interactor

    delegate :event, :history_store, :to_user_accept, to: :context

    def call
      context.to_user_accept = event.work.to_user_accepts.build(
        message: event.payload['message'],
        sender: event.user,
        accept_endpoint: event.payload['accept_endpoint']
      )

      history_store.add(Histories::ToUserAcceptType.new(message: event.payload['message']).build)

      if to_user_accept.save
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      else
        context.fail!(error: to_user_accept.errors.full_messages)
      end
    end
  end
end
