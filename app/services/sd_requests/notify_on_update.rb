module SdRequests
  # Вызывает воркер, отправляющий уведомление об изменении в заявке.
  class NotifyOnUpdate
    include Interactor

    delegate :sd_request, :history_store, to: :context

    def call
      SdRequests::UpdatedWorker.perform_async(sd_request.id) if history_store.histories.any?
    end
  end
end
