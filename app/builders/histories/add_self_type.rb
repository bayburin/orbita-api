# Класс создает историю с типом add_workers
module Histories
  class AddSelfType < BaseBuilder
    TYPE = 'add_self'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE) }
    end
  end
end
