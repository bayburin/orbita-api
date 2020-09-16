module Auth
  # Получает access_token у ЦА.
  class AccessToken
    include Interactor

    def call
      response = Api::AuthCenter.access_token(context.code)

      if response.success?
        context.auth_data = response.body
      else
        context.fail!(message: response.body, status: response.status)
      end
    end
  end
end
