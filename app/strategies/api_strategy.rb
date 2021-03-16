# Стратегия авторизации, проверяющая наличие пользователя в БД. если отсутствует, входит под гостевым пользователем.
class ApiStrategy < Warden::Strategies::Base
  def valid?
    access_token.present?
  end

  def authenticate!
    user = User.find_by(id_tn: params[:id_tn]) || User.authenticate_employee(params[:id_tn])

    if user
      success!(user)
    else
      Rails.logger.warn { 'Пользователь в базе не найден. Доступ запрещен.' }
      fail!('Доступ запрещен.')
    end
  end

  def access_token
    request.headers['Authorization'].to_s.remove('Bearer ')
  end
end
