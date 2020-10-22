module Events
  # Обрабатывает полученное событие, регистрирует список возможных событий и вызывает соответствующий класс.
  class Handler
    def self.call(params:)
      sw = Switch.new
      sw.register('action', Events::ActionEvent)
      sw.register('close', Events::CloseEvent)

      sw.call(Event.new(params))
    end
  end
end