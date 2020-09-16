module Auth
  # Создает JWT.
  class GenerateJwt
    include Interactor

    def call
      context.jwt = JWT.encode(context.user.as_json, ENV['AUTH_CENTER_APP_SECRET'], ENV['JWT_HMAC'])
    end
  end
end
