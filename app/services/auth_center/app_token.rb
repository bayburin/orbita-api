module AuthCenter
  # Возаращается токен приложения из redis, либо получает его у ЦА.
  class AppToken
    include Interactor

    delegate :token, to: :context

    def call
      context.token = AppTokenCache.token
      return if token

      response = Api.app_token
      if response.success?
        AppTokenCache.token = response.body
        context.token = AppTokenCache.token
      else
        context.fail!(error: response.body)
      end
    end
  end
end
