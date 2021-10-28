module Histories
  # Создает историю с типом comment
  class CommentType < BaseBuilder
    TYPE = 'comment'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, comment: params[:comment]) }
    end
  end
end
