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
        context.token = response.body
        AppTokenCache.token = token
      else
        context.fail!(error: response.body)
      end
    end
  end
end
