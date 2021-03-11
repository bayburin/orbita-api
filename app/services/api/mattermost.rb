module Api
  # Содержит API для обращения к Mattermost.
  class Mattermost
    include Connection

    API_ENDPOINT = ENV['MATTERMOST_NOTIFIER_URL']

    class << self
      # Отправить сообщение на указанный канал
      def notify(channel, message)
        body = {
          channel: channel,
          text: message
        }

        connect.post do |req|
          req.headers['Content-Type'] = 'application/json; charset=utf-8'
          req.body = body.to_json
        end
      rescue Faraday::ParsingError => e
        e.response
      end
    end
  end
end
