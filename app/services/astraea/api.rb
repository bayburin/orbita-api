module Astraea
  # Содержит API для обращения к Astraea.
  class Api
    include Connection

    API_ENDPOINT = ENV['ASTRAEA_URL']

    class << self
      def create_sd_request(sd_request, attachments = [])
        payload = {}
        payload[:sd_request] = Faraday::ParamPart.new(sd_request.to_json, 'application/json')
        payload[:attachments] = attachments.map do |attachment|
          Faraday::FilePart.new(attachment, attachment.content_type, attachment.original_filename)
        end

        multipart_connect.post('sd_requests.json', payload)
      end

      # def update_sd_request
      #   connect.put('sd_requests.json', data.to_json)
      # end
    end
  end
end
