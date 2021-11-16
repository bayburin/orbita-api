module Astraea
  # Синхронизирует данные с системой Astraea (создает заявку).
  class CreateSdRequest
    include Interactor

    delegate :form, :current_user, :new_files, to: :context

    def call
      form_data = FormAdapterSerializer.new(FormAdapter.new(form, current_user, 'new')).as_json
      Rails.logger.debug { "Данные в Astraea: #{form_data}" }
      astraea_response = Astraea::Api.save_sd_request(form_data, new_files)

      if astraea_response.success?
        Rails.logger.info { 'Данные в Astraea сохранены'.green }
        form.model.claim_applications.create(
          application_id: Doorkeeper::Application.find_by(name: 'Astraea').id,
          integration_id: JSON.parse(astraea_response.body)['case_id']
        )
      else
        Rails.logger.error { 'Ошибка. Данные в Astraea не сохранены'.red }
      end

    rescue Faraday::ConnectionFailed
      Rails.logger.error { 'Не удалось подключиться к системе Astraea'.red }

      nil
    end
  end
end
