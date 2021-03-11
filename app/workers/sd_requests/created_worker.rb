module SdRequests
  class CreatedWorker
    include Sidekiq::Worker

    def perform(sd_request_id)
      sd_request = SdRequest.find(sd_request_id)

      # TODO: Сделать broadcast каждому исполнителю через сокет.
      sd_request.users.each do |user|
        UserMailer.sd_request_created_email(user, sd_request).deliver_later
        NotifyUserOnCreateByMattermostWorker.perform_async(user.id, sd_request_id)
      end

      # TODO: Создать mailer для отправки почты работнику, создавшему заявку.
      Rails.logger.debug "Send notification to #{sd_request.source_snapshot.fio}"
    end
  end
end
