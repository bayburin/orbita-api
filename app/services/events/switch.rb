module Events
  # Класс-мапер для согласования каждого вида события (EventType) с обрабатывающим его классом.
  class Switch
    attr_reader :event_map

    # Регистрирует обработчик события.
    def register(name, command)
      @event_map ||= {}
      event_map[name] = command
    end

    # Вызывает обработчик события по полученному экземпляру класса Event.
    # event - объект класса Event
    def call(event)
      command = event_map[event.event_type.name]
      raise 'Неизвестное событие' unless command

      command.call(event: event)
    end
  end
end
