module Events
  # Отправляет ответ от пользователя на указанный endpoint внешней системы.
  class SendUserAnswer
    include Interactor

    delegate :from_user_accept, to: :context

    def call
      response = Api.send_user_answer(
        from_user_accept.accept_endpoint,
        from_user_accept.accept_value,
        from_user_accept.accept_comment
      )

      unless response.success?
        Rails.logger.error { "Не удалось отправить ответ от пользователя внешней системе по адресу #{from_user_accept.accept_endpoint}: #{response.body}".red }
      end
    end
  end
end
