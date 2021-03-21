module AuthCenter
  # Класс загружает данные по указанному хосту
  class HostInfoLoader
    STOP_COUNTER = 2

    def initialize
      @counter = 0
    end

    # value - значение поиска
    # search_key - параметр поиска (id | ip | mac | name)
    def load(value, search_key = 'id')
      if @counter == STOP_COUNTER
        @counter = 0

        return
      end

      @counter += 1

      host_info = AuthCenter::Api.host_info(token, value, search_key)

      if host_info.success?
        @counter = 0
        Rails.logger.debug "DATA: #{host_info.body}".red
        host_info.body
      else
        AuthCenter::AppTokenCache.clear
        load(value)
      end
    rescue RuntimeError => e
      Rails.logger.warn { e }
    end

    protected

    def token
      app_token = AppToken.call
      return app_token.token.access_token if app_token.success?

      Rails.logger.warn { "Ошибка: #{app_token.errors}".red }
      raise 'Не удалось получить токен для обращения к AuthCenter'
    end
  end
end
