module SdRequests
  # Вызывает воркер, рассылающий через сокет уведомление о создании заявки.
  class BroadcastOnCreate
    include Interactor

    delegate :sd_request, to: :context

    def call
      BroadcastCreatedRecordWorker.perform_async(sd_request.id)
    end
  end
end
