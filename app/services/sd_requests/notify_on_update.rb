module SdRequests
  # Вызывает воркер, отправляющий уведомление об изменении в заявке.
  class NotifyOnUpdate
    include Interactor

    delegate :sd_request, :history_store, to: :context

    def call
      if history_store.histories.any?
        UpdatedWorker.perform_async(sd_request.id)
        BroadcastUpdatedRecordWorker.perform_async(sd_request.id)
      end
    end
  end
end
