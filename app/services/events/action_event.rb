module Events
  class ActionEvent
    include Interactor

    def call
      p 'ActionEvent.call'
      # TODO: Создать запись в таблице messages с сообщением из payload. Добавить запись в таблицу histories.
    end
  end
end
