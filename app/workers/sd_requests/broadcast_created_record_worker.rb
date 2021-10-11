module SdRequests
  # Уведомляет по вебсокету клиентов о созданной заявке.
  class BroadcastCreatedRecordWorker
    include Sidekiq::Worker

    def perform(sd_request_id)
      # sd_request = SdRequest.find(sd_request_id)
      # data = SdRequestSerializer.new(sd_request).as_json(include: ['source_snapshot', 'comments', 'parameters', 'attachments', 'works.histories', 'works.workers', 'works.workflows'])
      ActionCable.server.broadcast('sd_requests::create', nil)
    end
  end
end
