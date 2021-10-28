module Events
  # Создает запись хода работы в таблице messages на основании полученного события Event.
  class CreateFromUserAccept
    include Interactor

    delegate :event, :history_store, :from_user_accept, to: :context

    def call
      context.from_user_accept = event.work.to_user_accepts.find(event.payload['id'])
      history_store.add(
        Histories::FromUserAcceptType.new(
          answer: event.payload['accept_value'] == true ? 'Согласовано' : 'Отклонено',
          comment: event.payload['accept_comment']
        ).build
      )

      if from_user_accept.update(accept_value: event.payload['accept_value'] == true, accept_comment: event.payload['accept_comment'])
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      else
        context.fail!(error: from_user_accept.errors.full_messages)
      end
    end
  end
end
