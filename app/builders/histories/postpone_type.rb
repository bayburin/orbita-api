module Histories
  # Создает историю с типом postpone
  class PostponeType < BaseBuilder
    TYPE = 'postpone'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, datetime: params[:datetime]) }
    end
  end
end
