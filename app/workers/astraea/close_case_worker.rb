module Astraea
  # Отправляет запрос в систему Astraea для закрытия заявки
  class CloseCaseWorker
    include Sidekiq::Worker

    def perform(case_id, tn)
      form_data = {
        close: 1,
        case_id: case_id,
        user_id: tn
      }
      Rails.logger.debug { "Данные в Astraea: #{form_data}" }
      astraea_response = Astraea::Api.close_case(form_data)

      if astraea_response.success?
        Rails.logger.info { 'Заявка в Astraea закрыта'.green }
      else
        Rails.logger.error { 'Ошибка. Заявка в Astraea не закрыта'.red }
      end

    rescue Faraday::ConnectionFailed
      Rails.logger.error { 'Не удалось подключиться к системе Astraea'.red }

      nil
    end
  end
end
