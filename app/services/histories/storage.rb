module Histories
  # Класс позволяет обрабатывать историю изменений по заявке в рамках изменений для текущего запроса.
  class Storage
    attr_reader :histories
    attr_accessor :work

    def initialize
      @histories = []
    end

    def add(history)
      histories << history
    end

    def save
      History.transaction do
        histories.each do |h|
          h.work = work
          h.save!
        end
      end
    end
  end
end
