module Events
  # Создает запись хода работы в таблице messages на основании полученного события Event.
  class CreateComment
    include Interactor

    delegate :event, :history_store, :comment, to: :context

    def call
      context.comment = event.claim.comments.build(
        message: event.payload['message'],
        sender: event.user
      )

      history_store.work = event.work
      history_store.add(Histories::CommentType.new(comment: event.payload['message']).build)

      if comment.save
        history_store.save!
      else
        context.fail!(error: comment.errors.full_messages)
      end
    end
  end
end
