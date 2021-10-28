module Histories
  # Создает историю с типом to_user_accept
  class ToUserAcceptType < BaseBuilder
    TYPE = 'to_user_accept'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, message: params[:message]) }
    end
  end
end
