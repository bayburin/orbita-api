module SdRequests
  # Уведомляет исполнителя о созданной заявке.
  class NotifyUserOnUpdateByMattermostWorker
    include Sidekiq::Worker

    def perform(user_id, sd_request_id)
      recipient = User.find(user_id)
      @sd_request = SdRequest.find(sd_request_id)
      file = Rails.root.join('app', 'views', 'mattermost', 'sd_request_updated_mattermost.text.erb').to_s
      html = File.open(file).read
      response = Mattermost::Api.notify("@#{recipient.login}", ERB.new(html).result(binding))

      raise StandardError.new(response.body) if response.status == 500
    end
  end
end
