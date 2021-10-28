module Histories
  # Создает историю с типом del_workers
  class DelWorkerType < BaseBuilder
    TYPE = 'del_workers'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, workers: params[:workers]) }
    end
  end
end
