# Класс создает историю с типом comment
module Histories
  class CommentType < BaseBuilder
    TYPE = 'comment'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, comment: params[:comment]) }
    end
  end
end
