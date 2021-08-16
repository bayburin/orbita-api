module Astraea
  # Синхронизирует данные с системой Astraea (обновляет заявку).
  class UpdateSdRequest
    include Interactor

    delegate :form, :current_user, :new_files, to: :context

    def call
      form_data = FormAdapterSerializer.new(FormAdapter.new(form, current_user)).as_json
      astraea_response = Astraea::Api.save_sd_request(form_data, new_files)

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
