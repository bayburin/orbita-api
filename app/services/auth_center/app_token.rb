module AuthCenter
  # Возаращается токен приложения из redis, либо получает его у ЦА.
  class AppToken
    include Interactor

    delegate :token, to: :context

    def call
      context.token = AuthCenter::AppTokenCache.token
      return if token

      response = Api.app_token
      if response.success?
        context.token = response.body
        AuthCenter::AppTokenCache.token = token
      else
        context.fail!(error: response.body)
      end
    end
  end
end
