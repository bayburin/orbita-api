class SdRequestsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug { "Пользователь #{current_user.fio} подключился к каналу SdRequestsChannel" }
    stream_from 'sd_requests'
  end

  def unsubscribed
    Rails.logger.debug { "Пользователь #{current_user.fio} отключился от канала SdRequestsChannel" }
  end
end
