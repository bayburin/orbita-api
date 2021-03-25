module SdRequests
  # Вызывает воркер, отправляющий уведомление об изменении в заявке.
  class NotifyOnUpdate
    include Interactor

    delegate :sd_request, to: :context

    def call
      SdRequests::UpdatedWorker.perform_async(sd_request.id)
    end
  end
end
