module SdRequests
  # Содержит API для обращения к СВТ.
  class Api
    # Посылает POST запрос на указанный URL с данными для создания заявки
    # url - адрес, куда отправить заявку
    # sd_request - заявка (объект SdRequest)
    # parameters - преобразованные параметры
    # files - массив файлов (объект CarrierWave::SanitizedFile)
    def self.create(url, sd_request, parameters, files = [])
      connection = Faraday.new(url: url) do |req|
        req.response :logger, Rails.logger, { bodies: true, log_level: :debug }
        req.request :multipart
        req.adapter Faraday.default_adapter
      end

      payload = {
        id: sd_request.id,
        description: sd_request.description,
        created_at: sd_request.created_at
      }
      payload[:parameters] = Faraday::ParamPart.new(parameters.to_json, 'application/json')
      payload[:files] = files.map do |attachment|
        Faraday::FilePart.new(attachment.file, attachment.content_type, attachment.original_filename)
      end

      connection.post('', payload)
    end
  end
end
