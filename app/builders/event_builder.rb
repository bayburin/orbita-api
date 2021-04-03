# Позволяет построить объект события Event.
class EventBuilder < BaseBuilder
  def initialize(params = {})
    @model = Event.new(params)

    super()
  end

  delegate :claim=, :user=, :payload=, to: :model

  def event_type=(event_type)
    model.event_type = EventType.find_by(name: event_type)
  end
end
