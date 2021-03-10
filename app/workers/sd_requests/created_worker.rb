class SdRequests::CreatedWorker
  include Sidekiq::Worker

  def perform(sd_request_id)
    # 1. Broadcast через сокеты

    # 2. Найти всех исполнителей
    # 3. Запустить воркер по отправке почты каждому исполнителю

    # 4. Отправить email пользователю
  end
end
