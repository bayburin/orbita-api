# Класс создает историю с типом open
module Histories
  class OpenType < BaseBuilder
    TYPE = 'open'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE) }
    end
  end
end
