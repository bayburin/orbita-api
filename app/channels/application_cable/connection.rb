module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'AnyCable', current_user.fio_initials
    end

    protected

    def find_verified_user
      user_info = AuthCenter::JsonWebToken.decode(request.parameters[:access_token])
      user = User.find_by(id_tn: user_info['id_tn'])

      if user
        user.auth_center_token = AuthCenterToken.new(user_info['auth_center_token'])
        user
      else
        reject_unauthorized_connection
      end
    rescue JWT::DecodeError => e
      Rails.logger.warn { "Ошибка авторизации AnyCable: Невалидный токен. #{e.message}".red }
      reject_unauthorized_connection
    end
  end
end
