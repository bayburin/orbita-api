module SdRequests
  # Отправляет все необходимые уведомления всем участникам заявки после обновления заявки.
  class UpdatedWorker
    include Sidekiq::Worker

    def perform(sd_request_id)
      sd_request = SdRequest.find(sd_request_id)

      BroadcastUpdatedRecordWorker.perform_async(sd_request_id)
      sd_request.users.each do |user|
        UserMailer.sd_request_updated_email(user, sd_request).deliver_later
        NotifyUserOnUpdateByMattermostWorker.perform_async(user.id, sd_request_id)
      end
    end
  end
end
