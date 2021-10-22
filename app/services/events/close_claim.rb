module Events
  # Закрывает заявку.
  class CloseClaim
    include Interactor

    delegate :event, :history_store, to: :context

    def call
      event.claim.finished_at = Time.zone.now
      event.claim.status = :done

      history_store.add(Histories::CloseType.new.build)

      if event.claim.save
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      else
        context.fail!(error: event.claim.errors.full_messages)
      end
    end
  end
end
