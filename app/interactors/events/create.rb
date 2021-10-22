module Events
  # Обрабатывает полученное событие, регистрирует список возможных событий и вызывает соответствующий класс-обработчик.
  class Create
    def self.call(claim:, user:, event_type:, payload: {}, files: [], need_update_astraea: false)
      sw = Events::Switch.new
      sw.register('workflow', Events::WorkflowEvent)
      sw.register('close', Events::CloseEvent)
      sw.register('add_files', Events::AddFilesEvent)

      event = EventBuilder.build do |builder|
        builder.event_type = event_type
        builder.payload = payload
        builder.files = files
        builder.user = user
        builder.claim = claim
      end
      sw.call(event, need_update_astraea)
    end
  end
end
