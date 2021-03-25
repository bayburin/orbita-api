module SdRequests
  # Вызывает воркер, отправляющий уведомление о создании заявки.
  class NotifyOnCreate
    include Interactor

    delegate :sd_request, to: :context

    def call
      SdRequests::CreatedWorker.perform_async(sd_request.id)
    end
  end
end
