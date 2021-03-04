module Auth
  # Получает данные о пользователе у ЦА.
  class UserInfo
    include Interactor

    def call
      response = Api::AuthCenter.login_info(context.auth_data['access_token'])

      if response.success?
        context.user_info = response.body
      else
        context.fail!(message: response.body, status: response.status)
      end
    end
  end
end
