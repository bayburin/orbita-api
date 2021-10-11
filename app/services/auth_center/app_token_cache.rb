module AuthCenter
  # Содержит методы для работы с access_token приложения, выданные AuthCenter
  class AppTokenCache
    TOKEN_NAME = 'app_access_token'.freeze

    class << self
      # Возвращает токен из redis в виде объекта AuthCenterToken.
      def token
        token = ReadCache.redis.get(TOKEN_NAME)
        token ? AuthCenterToken.new(Oj.load(token)) : nil
      end

      # Сохраняет токен в redis.
      def token=(access_token)
        ReadCache.redis.set(TOKEN_NAME, Oj.dump(access_token))
      end

      # Удаляет токен из redis.
      def clear
        ReadCache.redis.del(TOKEN_NAME)
      end
    end
  end
end
