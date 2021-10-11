module AuthCenter
  # Создает JWT.
  class GenerateJwt
    include Interactor

    def call
      user_data = UserSerializer.new(context.user).as_json
      context.jwt = JsonWebToken.encode(user_data)
    end
  end
end
