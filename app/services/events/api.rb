module Events
  # Содержит API для обращения к СВТ.
  class Api
    class << self
      # Посылает POST запрос на указанный URL с ответом пользователя
      def send_user_answer(url, answer, comment)
        connection = Faraday.new(url) do |req|
          req.response :logger, Rails.logger
          req.response :json
          req.adapter Faraday.default_adapter
          req.headers['Content-Type'] = 'application/json'
          req.headers['Accept'] = 'application/json'
        end

        connection.post do |req|
          req.body = { answer: answer, comment: comment }.to_json
        end
      end
    end
  end
end
