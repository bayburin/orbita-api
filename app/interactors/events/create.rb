module Events
  # Обрабатывает полученное событие, регистрирует список возможных событий и вызывает соответствующий класс-обработчик.
  class Create
    def self.call(claim:, user:, event_type:, payload: {}, files: [], need_update_astraea: false)
      sw = Events::Switch.new
      sw.register('workflow', Events::WorkflowEvent)
      sw.register('close', Events::CloseEvent)
      sw.register('add_files', Events::AddFilesEvent)
      sw.register('to_user_message', Events::ToUserMessageEvent)
      sw.register('to_user_accept', Events::ToUserAcceptEvent)
      sw.register('from_user_accept', Events::FromUserAcceptEvent)
      sw.register('add_workers', Events::AddWorkersEvent)

      event = EventBuilder.build do |builder|
        builder.event_type = event_type
        builder.payload = payload if payload
        builder.files = files
        builder.user = user
        builder.claim = claim
      end
      sw.call(event, need_update_astraea)
    end
  end
end
