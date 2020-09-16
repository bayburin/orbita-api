module Auth
  # Авторизует пользователя в системе.
  class Authorize
    include Interactor::Organizer

    organize AccessToken, UserInfo, UpdateUser, GenerateJwt
  end
end
