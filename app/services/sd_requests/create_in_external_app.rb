module SdRequests
  # Создает заявку во внешней системе
  class CreateInExternalApp
    include Interactor

    delegate :sd_request, to: :context

    def call
      endpoint =
        case sd_request.ticket_identity
        when 783 then 'https://svt.iss-reshetnev.ru/requests'
        end

      files = sd_request.attachments.map(&:attachment)
      parameters = sd_request.parameter&.payload_for_external_app
      response = Api.create(endpoint, sd_request, parameters, files)

      unless response.success?
        Rails.logger.error { "Не удалось создать заявку по адресу #{endpoint}: #{response.body}".red }
      end
    end
  end
end
