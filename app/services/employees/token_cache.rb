module Employees
  # Содержит методы для работы с access_token, выданный НСИ
  class TokenCache
    TOKEN_NAME = 'employee_token'.freeze

    class << self
      # Возвращает токен из redis.
      def token
        ReadCache.redis.get(TOKEN_NAME)
      end

      # Записывает токен в redis.
      def token=(access_token)
        ReadCache.redis.set(TOKEN_NAME, access_token)
      end

      # Удаляет токен из redis.
      def clear
        ReadCache.redis.del(TOKEN_NAME)
      end
    end
  end
end
