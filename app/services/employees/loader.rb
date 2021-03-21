module Employees
  # Предоставляет интерфейс для обращения к API НСИ.
  class Loader
    STOP_COUNTER = 2

    def initialize(type)
      @type = type
      @counter = 0
    end

    def load(params)
      if @counter == STOP_COUNTER
        @counter = 0

        return
      end

      @counter += 1
      response = UserRequestSwitcher.request(@type, token, params)

      if response.success?
        @counter = 0
        response.body
      else
        Employees::TokenCache.clear
        load(params)
      end
    end

    protected

    def token
      token = Token.call
      return token.token if token.success?

      Rails.logger.warn { "Ошибка: #{token.error}".red }
      raise 'Не удалось получить токен авторизации на сервере НСИ.'
    end
  end
end
