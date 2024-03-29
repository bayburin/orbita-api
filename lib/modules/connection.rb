# Модуль для установки соединения с внешним API.
module Connection
  def self.included(base)
    base.extend(ClassMethods)
  end

  API_ENDPOINT = 'http://api_url_not_defined'.freeze

  def multipart_connect
    Faraday.new(url: api_const) do |faraday|
      faraday.response :logger, Rails.logger, { bodies: true, log_level: :debug }
      faraday.request :multipart
      faraday.adapter Faraday.default_adapter
    end
  end

  def connect
    Faraday.new(url: api_const) do |faraday|
      faraday.response :logger, Rails.logger
      faraday.response :json
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
      faraday.headers['Accept'] = 'application/json'
    end
  end

  def api_const
    self.class.const_get(:API_ENDPOINT)
  end

  module ClassMethods
    def multipart_connect
      Faraday.new(url: api_const) do |faraday|
        faraday.response :logger, Rails.logger
        faraday.request :multipart
        faraday.adapter Faraday.default_adapter
      end
    end

    def connect
      Faraday.new(url: api_const) do |faraday|
        faraday.response :logger, Rails.logger
        faraday.response :json
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
        faraday.headers['Accept'] = 'application/json'
      end
    end

    def api_const
      const_get(:API_ENDPOINT)
    end
  end
end
