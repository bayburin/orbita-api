module AuthCenter
  # Содержит методы для работы с access_token
  module AppAccessTokenCache
    TOKEN_NAME = 'app_access_token'.freeze

    # Возвращает токен.
    def self.get
      token = ReadCache.redis.get(TOKEN_NAME)
      token ? Oj.load(token) : token
    end

    # Сохраняет токен.
    def self.set(access_token)
      ReadCache.redis.set(TOKEN_NAME, Oj.dump(access_token))
    end

    # Удаляет токен.
    def self.del
      ReadCache.redis.del(TOKEN_NAME)
    end
  end
end
