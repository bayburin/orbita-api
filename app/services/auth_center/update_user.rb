module AuthCenter
  # Обновляет данные о пользователе.
  class UpdateUser
    include Interactor

    delegate :user_info, :auth_data, to: :context

    def call
      user = User.find_by(id_tn: user_info['id_tn'])
      context.fail!(message: 'Доступ запрещен') unless user

      if user.update(
        tn: user_info['tn'],
        fio: user_info['fio'],
        work_tel: user_info['tel'],
        email: user_info['email']
      )
        context.user = user
        context.user.auth_center_token = AuthCenterToken.new(auth_data)
      else
        context.fail!(message: user.errors.full_messages)
      end
    end
  end
end
