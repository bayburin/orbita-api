module Histories
  # Создает историю с типом add_files
  class AddFilesType < BaseBuilder
    TYPE = 'add_files'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, files: params[:files]) }
    end
  end
end
