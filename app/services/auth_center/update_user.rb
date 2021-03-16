module AuthCenter
  # Обновляет данные о пользователе.
  class UpdateUser
    include Interactor

    def call
      user = User.find_by(id_tn: context.user_info['id_tn'])
      context.fail!(message: 'Доступ запрещен') unless user

      if user.update(
        tn: context.user_info['tn'],
        fio: context.user_info['fio'],
        work_tel: context.user_info['tel'],
        email: context.user_info['email']
      )
        context.user = user
        context.user.auth_center_token = AuthCenterToken.new(context.auth_data)
      else
        context.fail!(message: user.errors.full_messages)
      end
    end
  end
end
