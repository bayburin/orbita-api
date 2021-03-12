# Класс содержит методы для отправки email работникам, оставляющим заявки.
class EmployeeMailer < ApplicationMailer
  # Отправляет email с уведомлением о создании заявки.
  def sd_request_created_email(fio, email, sd_request)
    unless email
      Rails.logger.info { "Email для #{fio} отсутствует" }

      return
    end

    @fio = fio
    @sd_request = sd_request

    mail(
      to: "#{fio} <#{email}>",
      subject: "Портал \"Орбита\": создана новая заявка №#{sd_request.id}"
    )
  end
end
