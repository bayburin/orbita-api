# Класс создает историю с типом postpone
module Histories
  class PostponeType < BaseBuilder
    TYPE = 'postpone'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, datetime: params[:datetime]) }
    end
  end
end
