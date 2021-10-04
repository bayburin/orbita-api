module SdRequests
  # Отправляет все необходимые уведомления всем участникам заявки после создания заявки.
  class CreatedWorker
    include Sidekiq::Worker

    def perform(sd_request_id)
      sd_request = SdRequest.find(sd_request_id)

      BroadcastCreatedRecordWorker.perform_async(sd_request_id)
      sd_request.users.each do |user|
        UserMailer.sd_request_created_email(user, sd_request).deliver_later
        NotifyUserOnCreateByMattermostWorker.perform_async(user.id, sd_request_id)
      end

      NotifyEmployeeOnCreateByEmailWorker.perform_async(sd_request_id)
    end
  end
end
