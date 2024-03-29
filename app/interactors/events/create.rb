module Events
  # Обрабатывает полученное событие, регистрирует список возможных событий и вызывает соответствующий класс-обработчик.
  class Create
    def self.call(claim:, user:, params:, need_update_astraea: false)
      sw = Events::Switch.new
      sw.register('workflow', Events::WorkflowEvent)
      sw.register('close', Events::CloseEvent)

      event = EventBuilder.build(params) do |builder|
        builder.user = user
        builder.claim = claim
      end
      sw.call(event, need_update_astraea)
    end
  end
end
