# Класс создает историю с типом created
module Histories
  class CreateType < BaseBuilder
    TYPE = 'created'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE) }
    end
  end
end
