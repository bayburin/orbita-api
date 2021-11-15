module SdRequests
  # Создает заявку во внешней системе
  class CreateInExternalApp
    include Interactor

    delegate :sd_request, to: :context

    def call
      application, endpoint =
        case sd_request.ticket_identity
        when 783
          [Doorkeeper::Application.find_by(name: 'СВТ'), ENV['TMP_SVT_NEW_PC']]
        end

      files = sd_request.attachments.map { |attachment| attachment.attachment.file }
      parameters = sd_request.parameter&.payload_for_external_app
      response = Api.create(endpoint, sd_request, parameters, files)

      if response.success?
        sd_request.claim_applications.create(
          application_id: application.id,
          integration_id: JSON.parse(response.body)['id']
        )
      else
        Rails.logger.error { "Не удалось создать заявку по адресу #{endpoint}: #{response.body}".red }
      end
    rescue Encoding::CompatibilityError
      Rails.logger.error { "Не удалось создать заявку по адресу #{endpoint}".red }
    end
  end
end
