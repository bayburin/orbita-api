module Events
  # Закрывает заявку.
  class CloseClaim
    include Interactor

    delegate :event, :history_store, to: :context

    def call
      event.claim.finished_at = Time.zone.now

      history_store.work = event.work
      history_store.add(Histories::CloseType.new.build)

      if event.claim.save
        history_store.save!
      else
        context.fail!(error: event.claim.errors.full_messages)
      end
    end
  end
end
