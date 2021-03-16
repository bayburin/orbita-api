# Стратегия авторизации, проверяющая наличие пользователя в БД. если отсутствует, входит под гостевым пользователем.
class ApiStrategy < Warden::Strategies::Base
  def valid?
    access_token.present?
  end

  def authenticate!
    user = User.find_by(id_tn: params[:id_tn])
    unless user
      user = User.find_by(role: Role.find_by(name: :employee))
      user_info = Employees::Loader.new(:load).load(params[:id_tn])
      # ! TODO: Что делать, если НСИ не отвечает
      unless user_info
        Rails.logger.warn { 'Не удалось загрузить данные о пользователе.' }
        fail!('Доступ запрещен')
      end
      user.tn = user_info['employeePositions'].first['personnelNo']
      user.id_tn = params[:id_tn]
      user.login = user_info['employeeContact']['login']
      user.fio = "#{user_info['lastName']} #{user_info['firstName']} #{user_info['middleName']}"
      user.work_tel = user_info['employeeContact']['phone'].first
      user.email = user_info['employeeContact']['email'].first
    end

    if user
      Rails.logger.debug "USER: #{user}".red
      success!(user)
    else
      Rails.logger.warn { 'Пользователь в базе не найден. Доступ запрещен.' }
      fail!('Доступ запрещен')
    end
  end

  def access_token
    request.headers['Authorization'].to_s.remove('Bearer ')
  end
end
