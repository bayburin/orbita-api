module Histories
  # Класс позволяет обрабатывать историю изменений по заявке в рамках текущего запроса.
  class Storage
    attr_reader :histories
    attr_accessor :work, :user

    def initialize(user)
      @histories = []
      @user = user
    end

    def add(history)
      histories << history
    end

    def save!
      History.transaction do
        histories.each do |h|
          h.work = work
          h.user = user
          h.save!
        end
      end
    end
  end
end
