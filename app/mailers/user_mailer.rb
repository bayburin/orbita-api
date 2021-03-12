# Класс содержит методы для отправки email исполнителям.
class UserMailer < ApplicationMailer
  # Отправляет email с уведомлением о создании заявки.
  def sd_request_created_email(recipient, sd_request)
    unless recipient.email
      Rails.logger.info { "Email для #{recipient.fio} отсутствует" }

      return
    end

    @sd_request = sd_request

    mail(
      to: "#{recipient.fio} <#{recipient.email}>",
      subject: "Портал \"Орбита\": создана новая заявка №#{sd_request.id}"
    )
  end
end
