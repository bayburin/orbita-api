module Events
  # Класс-мапер для согласования событий и обрабатывающие их классы.
  class Switch
    attr_reader :event_map

    # Регистрирует обработчик события.
    def register(name, command)
      @event_map ||= {}
      @event_map[name] = command
    end

    # Вызывает обработчик события по полученному экземпляру класса Event.
    def call(event)
      command = @event_map[event.type]
      raise 'Неизвестное событие' unless command

      command.call(event: event)
    end
  end
end
