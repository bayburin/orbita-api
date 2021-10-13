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
    # need_update_astraea? - флаг, показывающий, нужно ли отправлять событию в систему Astraea
    def call(event, need_update_astraea = false)
      command = event_map[event.event_type.name]
      raise 'Неизвестное событие' unless command

      command.call(event: event, need_update_astraea: need_update_astraea)
    end
  end
end
