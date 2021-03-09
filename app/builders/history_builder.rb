# Позволяет построить объект события Event.
class HistoryBuilder < BaseBuilder
  def initialize(params = {})
    @model = History.new(params)

    super()
  end

  delegate :user, :work, to: :model

  def set_event_type(type, **payload)
    event_type = EventType.find_by(name: type)
    raise 'Неизвестный тип EventType' unless event_type

    model.event_type = event_type
    model.action = event_type.template

    terms = event_type.template.scan(/{(\w+)}/).flatten
    terms.each { |term| model.action.gsub!(/{#{term}}/, payload[term.to_sym]) }
  end
end
