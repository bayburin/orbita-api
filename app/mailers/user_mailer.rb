class UserMailer < ApplicationMailer
  # Отправляет email с уведомлением о создании заявки.
  def question_created_email(recipient, sd_request)
    unless recipient.email
      Rails.logger.info { "Email для #{recipient.fio} отсутствует" }

      return
    end

    mail(
      to: "#{recipient.fio} <#{recipient.email}>",
      subject: "Портал \"Орбита\": создана новая заявка №#{sd_request.id}"
    )
  end
end
