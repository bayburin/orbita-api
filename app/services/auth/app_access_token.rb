module Auth
  # Получает access_token приложения у ЦА.
  class AppAccessToken
    include Interactor

    delegate :token, to: :context

    def call
      context.token = AuthCenter::AppAccessTokenCache.get
      return if token

      response = Api::AuthCenter.app_access_token
      if response.success?
        context.token = response.body
        AuthCenter::AppAccessTokenCache.set(token)
      else
        context.fail!(message: response.body)
      end
    end
  end
end
