# Класс создает историю с типом closed
module Histories
  class CloseType < BaseBuilder
    TYPE = 'close'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE) }
    end
  end
end
