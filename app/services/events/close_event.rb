module Events
  class CloseEvent
    include Interactor

    def call
      p 'CloseEvent.call'
      # TODO: Закрыть заявку. Добавить запись в таблицу histories.
    end
  end
end
