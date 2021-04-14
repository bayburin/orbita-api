# Стратегия авторизации, проверяющая наличие пользователя в БД. если отсутствует, входит под гостевым пользователем.
class ApiStrategy < Warden::Strategies::Base
  def valid?
    params_valid?
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

  def params_valid?
    params[:id_tn].present?
  end
end
