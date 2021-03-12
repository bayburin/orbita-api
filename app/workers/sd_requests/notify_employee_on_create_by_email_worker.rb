module SdRequests
  # Уведомляет пользователя о созданной заявке.
  class NotifyEmployeeOnCreateByEmailWorker
    include Sidekiq::Worker

    def perform(sd_request_id)
      sd_request = SdRequest.find(sd_request_id)
      @snapshot = sd_request.source_snapshot
      email = @snapshot.user_attrs['email'] || load_email

      unless email
        Rails.logger.info { "Email для работника #{@snapshot.fio} отсутствует" }

        return
      end

      EmployeeMailer.sd_request_created_email(@snapshot.fio, email, sd_request).deliver_now
    end

    protected

    def load_email
      user_info = Employees::Employee.new(:load).load(@snapshot.id_tn)

      if user_info
        user_info['employeeContact']['email'].first
      else
        raise "Не удалось загрузить email для работника #{@snapshot.fio}"
      end
    end
  end
end
