module Histories
  # Создает историю с типом open
  class OpenType < BaseBuilder
    TYPE = 'open'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE) }
    end
  end
end
