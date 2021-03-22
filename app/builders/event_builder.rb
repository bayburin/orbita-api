# Позволяет построить объект события Event.
class EventBuilder < BaseBuilder
  def initialize(params = {})
    @model = Event.new(params)

    super()
  end

  delegate :claim=, :user=, :payload=, to: :model

  def claim_id=(claim_id)
    model.claim = Claim.find_by(id: claim_id)
  end

  def event_type=(event_type)
    model.event_type = EventType.find_by(name: event_type)
  end
end
