# Класс создает историю с типом priority
module Histories
  class PriorityType < BaseBuilder
    TYPE = 'priority'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, priority: params[:priority]) }
    end
  end
end
