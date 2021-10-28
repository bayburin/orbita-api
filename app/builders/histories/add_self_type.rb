module Histories
  # Создает историю с типом add_workers
  class AddSelfType < BaseBuilder
    TYPE = 'add_self'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE) }
    end
  end
end
