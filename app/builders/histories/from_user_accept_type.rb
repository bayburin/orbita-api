module Histories
  # Создает историю с типом from_user_accept
  class FromUserAcceptType < BaseBuilder
    TYPE = 'from_user_accept'.freeze

    def build
      comment = params[:comment] ? "Комментарий от пользователя: #{params[:comment]}" : ''
      HistoryBuilder.build { |h| h.set_event_type(TYPE, answer: params[:answer], comment: comment) }
    end
  end
end
