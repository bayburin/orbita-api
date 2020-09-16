# Класс предназначен для работы с JWT в приложении.
class JsonWebToken
  SECRET_KEY = ENV['AUTH_CENTER_APP_SECRET']
  HMAC = ENV['JWT_HMAC']

  # Закодировать JWT.
  # ? TODO: Возможно стоит обрабатывать expired_time. Но у ЦА он слишком долгий.
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY, HMAC)
  end

  # Раскодировать JWT.
  def self.decode(jwt)
    payload = JWT.decode(jwt, SECRET_KEY, true, algorithm: HMAC)[0]
    HashWithIndifferentAccess.new payload
  end
end
