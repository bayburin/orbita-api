module Histories
  # Создает историю с типом add_workers
  class AddWorkerType < BaseBuilder
    TYPE = 'add_workers'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, workers: params[:workers]) }
    end
  end
end
