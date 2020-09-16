# Стратегия авторизации, проверяющая валидность JWT и наличие пользователя в базе.
class AuthCenterStrategy < Warden::Strategies::Base
  def valid?
    access_token.present?
  end

  def authenticate!
    user_info = JsonWebToken.decode(access_token)
    user = User.find_by(id_tn: user_info[:id_tn])

    if user
      success!(user)
    else
      Rails.logger.debug { 'Пользователь в базе не найден. Доступ запрещен.' }
      fail!('Доступ запрещен')
    end
  rescue JWT::DecodeError => e
    Rails.logger.debug { "Error: Invalid Token. #{e.message}".red }
    fail!('Не валидный токен')
  end

  def access_token
    request.headers['Authorization'].to_s.remove('Bearer ')
  end
end
