module Auth
  # Авторизует пользователя в системе.
  class Authorize
    include Interactor::Organizer

    organize ClientAccessToken, UserInfo, UpdateUser, GenerateJwt
  end
end
