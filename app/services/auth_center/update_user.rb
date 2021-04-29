module AuthCenter
  # Обновляет данные о пользователе.
  class UpdateUser
    include Interactor

    delegate :user_info, :auth_data, to: :context

    def call
      user = User.find_by(id_tn: user_info['id_tn'])
      context.fail!(message: 'Доступ запрещен') unless user

      email = user_info['email'].to_s.empty? ? nil : "#{user_info['email']}@iss-reshetnev.ru"
      if user.update(
        tn: user_info['tn'],
        fio: user_info['fio'],
        work_tel: user_info['tel'],
        email: email
      )
        context.user = user.reload
        context.user.auth_center_token = AuthCenterToken.new(auth_data)
      else
        context.fail!(message: user.errors.full_messages)
      end
    end
  end
end
