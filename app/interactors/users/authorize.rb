module Users
  # Выполняет процесс авторизации, после которого пользователь получает JWT.
  class Authorize
    include Interactor::Organizer

    organize AuthCenter::ClientToken, AuthCenter::UserInfo, AuthCenter::UpdateUser, AuthCenter::GenerateJwt
  end
end
