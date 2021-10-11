module AuthCenter
  # Получает access_token пользователя у ЦА.
  class ClientToken
    include Interactor

    def call
      response = Api.client_token(context.code)

      if response.success?
        context.auth_data = response.body
      else
        context.fail!(message: response.body, status: response.status)
      end
    end
  end
end
