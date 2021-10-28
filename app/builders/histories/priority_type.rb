module Histories
  # Создает историю с типом priority
  class PriorityType < BaseBuilder
    TYPE = 'priority'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, priority: params[:priority]) }
    end
  end
end
