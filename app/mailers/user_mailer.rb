class UserMailer < ApplicationMailer
  # Отправляет email с уведомлением о создании заявки.
  def question_created_email(delivery_user, sd_request)
    unless delivery_user.email
      Rails.logger.info { "Email для #{delivery_user.fio} отсутствует" }

      return
    end

    mail(
      to: "#{delivery_user.fio} <#{delivery_user.email}>",
      subject: "Портал \"Орбита\": создана новая заявка №#{sd_request.id}"
    )
  end
end
