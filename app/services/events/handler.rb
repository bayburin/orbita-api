module Events
  # Обрабатывает полученное событие, регистрирует список возможных событий и вызывает соответствующий класс.
  class Handler
    def self.call(params:)
      sw = Switch.new
      sw.register('workflow', Events::WorkflowEvent)
      sw.register('close', Events::CloseEvent)

      sw.call(EventBuilder.build(params))
    end
  end
end
