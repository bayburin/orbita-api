module Histories
  # Создает историю с типом to_user_message
  class ToUserMessageType < BaseBuilder
    TYPE = 'to_user_message'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, message: params[:message]) }
    end
  end
end
