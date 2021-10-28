module Histories
  # Создает историю с типом del_files
  class DelFilesType < BaseBuilder
    TYPE = 'del_files'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, files: params[:files]) }
    end
  end
end
