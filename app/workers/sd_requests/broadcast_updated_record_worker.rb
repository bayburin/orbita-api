module SdRequests
  # Уведомляет по вебсокету клиентов об изменениях в заявке.
  class BroadcastUpdatedRecordWorker
    include Sidekiq::Worker

    def perform(sd_request_id)
      sd_request = SdRequest.find(sd_request_id)
      data = SdRequestSerializer.new(sd_request)
        .as_json(include: ['*', 'works.histories', 'works.workers', 'works.workflows'])
      ActionCable.server.broadcast('sd_requests::update', { payload: data })
    end
  end
end
