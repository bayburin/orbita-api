module Events
  # Обрабатывает полученное событие, регистрирует список возможных событий и вызывает соответствующий класс.
  class Create
    def self.call(params:)
      sw = Events::Switch.new
      sw.register('workflow', Events::WorkflowEvent)
      sw.register('close', Events::CloseEvent)

      sw.call(EventBuilder.build(params))
    end
  end
end
