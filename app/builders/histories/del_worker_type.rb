# Класс создает историю с типом del_workers
module Histories
  class DelWorkerType < BaseBuilder
    TYPE = 'del_workers'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, workers: params[:workers]) }
    end
  end
end
