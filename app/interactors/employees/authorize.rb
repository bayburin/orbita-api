module Employees
  # Класс авторизует приложение на сервере НСИ.
  class Authorize
    include Interactor

    delegate :token, to: :context

    def call
      response = Api.token

      if response.success?
        context.token = response.body['token']
        TokenCache.token = token
      else
        context.fail!(error: response.body)
      end
    end
  end
end
