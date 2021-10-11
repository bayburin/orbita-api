module Astraea
  # Синхронизирует данные с системой Astraea (добавляет комментарий).
  class AddComment
    include Interactor

    delegate :comment, to: :context

    def call
      form_data = CommentAdapterSerializer.new(comment).as_json
      astraea_response = Astraea::Api.save_sd_request(form_data)
      Rails.logger.debug { "Данные в Astraea: #{form_data}" }

      if astraea_response.success?
        Rails.logger.info { 'Данные в Astraea обновлены'.green }
      else
        Rails.logger.error { 'Ошибка. Данные в Astraea не обновлены'.red }
      end
    rescue Faraday::ConnectionFailed
      Rails.logger.error { 'Не удалось подключиться к системе Astraea'.red }

      nil
    end
  end
end
