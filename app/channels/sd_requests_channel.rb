class SdRequestsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'sd_requests'
    stream_from "notify_#{current_user.tn}"
    Rails.logger.debug "Пользователь #{current_user.fio} подключился к каналу SdRequestsChannel"
  end

  def unsubscribed
    Rails.logger.debug "Пользователь #{current_user.fio} отключился от канала SdRequestsChannel"
  end
end
