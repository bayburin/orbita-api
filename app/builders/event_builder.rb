# Позволяет построить объект события Event.
class EventBuilder < ApplicationBuilder
  def initialize(params = {})
    @model = Event.new(params)
  end

  def claim_id=(claim_id)
    model.claim_id = claim_id
  end

  def event_type=(event_type)
    model.event_type = EventType.find_by(name: event_type)
  end

  def user_name=(user_name)
    model.user_name = user_name
  end

  def id_tn=(id_tn)
    model.id_tn = id_tn
  end

  def payload=(payload)
    model.payload = payload
  end
end
